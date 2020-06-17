/*********************************************
 * OPL 12.10.0.0 Model
 * Author: HP
 * Creation Date: 15 juin 2020 at 14:23:39
 *********************************************/

main
{
function ascending(u,v){
    if (u>v) return 1
    if (u<v) return -1
    if (u == v) return 0
  }
  function loadNewSolution(){
  	  var currentSolution = new Array(rc2.oplModel.addedSlack.solutionValue.size);
  	for(var i=0 ; i<rc2.oplModel.addedSlack.solutionValue.size;i++){
    	currentSolution[i] = rc2.oplModel.addedSlack.solutionValue[i]
  	} 
  	return currentSolution
  }
    function loadNonSortedSolution(){
  	 
  		var currentSolution = new Array(rc2.oplModel.addedSlack.solutionValue.size);
  		for(var i=0 ; i<rc2.oplModel.addedSlack.solutionValue.size;i++){
    		currentSolution[i] = rc2.oplModel.addedSlack.solutionValue[i]
  	} 
  	return currentSolution
 }
 
 function sumAllSlack(){
 	var sum=0; 
   var currentSolution = new Array(rc2.oplModel.addedSlack.solutionValue.size);
 
    	for(var i=0 ; i<rc2.oplModel.addedSlack.solutionValue.size;i++){
				currentSolution[i] = rc2.oplModel.addedSlack.solutionValue[i]
    			sum = sum +currentSolution[i]	
  	} 
  	return sum 
 }  	
 function sumVector(team){
 	var sum=0; 
   var currentSolution = new Array(rc2.oplModel.addedSlack.solutionValue.size);
 
    	for(var i=0 ; i<rc2.oplModel.addedSlack.solutionValue.size;i++){
    		if(rc1.oplModel.teams[i] == team){ 
				currentSolution[i] = rc2.oplModel.addedSlack.solutionValue[i]
    			sum = sum +currentSolution[i]
    		}    		
  	} 
  	return sum
 }  
 function hasSameSlack(){ 
 	 for(var i=1 ; i<rc1.oplModel.nbteams;i++){
 	 	if(sumVector(i) !=sumVector(i+1));
 	 		return 0
  		} 	 
  	return 1	
 } 	



 var rc1 = new IloOplRunConfiguration(
    "PERTCPMOptimization.mod","ExampleGraph.dat");
 rc1.oplModel.generate();
 var best;
  var curr = Infinity;
  var basis = new IloOplCplexBasis();
 while ( 1 ) {
    best = curr;
    if ( rc1.cplex.solve() ) {
      curr = rc1.cplex.getObjValue();     
    } 
    else {
      writeln("No solution!");
      break;
    }
    if ( best==curr ) break;
  }    
 
   var f = new IloOplOutputFile();
   f.open("slack0.dat");
   var slackVector = new Array(rc1.oplModel.slack.solutionValue.size);
  	for(var i=0 ; i<rc1.oplModel.slack.solutionValue.size;i++){
    	slackVector[i] = rc1.oplModel.slack.solutionValue[i]
  	} 
   f.writeln("len="+(rc1.oplModel.slack.solutionValue.size-1)+";")
   f.writeln("slackVector=");
   f.writeln("["+slackVector.join()+"]");
   f.writeln(";");
   f.close();
   


 var rc2 = new IloOplRunConfiguration(
    "LeximinOptimization.mod","slack0.dat");
    var f = new IloOplOutputFile();
   f.open("leximin.dat");
   
   rc2.oplModel.generate();
   rc2.cp.startNewSearch();
   
   var bestSolution = new Array();
   var bestNonSortedSolution = new Array();
   var currentNonSortedSolution = new Array();
   var currentSolution;
   
   rc2.cp.next()
   
   currentSolution = loadNewSolution();
   
   bestNonSortedSolution =loadNonSortedSolution();
   currentNonSortedSolution =loadNonSortedSolution();
   
   currentSolution.sort(ascending);
  	
  	bestSolution = currentSolution;
  	
   while(rc2.cp.next()){
      
    //compute current solution
    currentSolution = loadNewSolution();
  	currentNonSortedSolution =loadNonSortedSolution();
  	//is current solution better
  	currentSolution.sort(ascending);
  	
	if(hasSameSlack()==0)continue 	
    for(var j=0;  j<rc2.oplModel.addedSlack.solutionValue.size;j++){
    	if(currentSolution[j] == bestSolution[j]){
    		continue; 
    	}  
    	if(currentSolution[j] > bestSolution[j]){
    		bestSolution = currentSolution
    		bestNonSortedSolution =currentNonSortedSolution;
    		break    	
    	}  
    }
   
   }
   
    
   f.writeln(""+ bestNonSortedSolution.join())
   f.close()
   
}