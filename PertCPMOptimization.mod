/*********************************************
 * OPL 12.9.0.0 Model
 * Author: HP
 * Creation Date: 23 avr. 2020 at 09:40:15
 *********************************************/

tuple Edge {
	int origin;
	int destination;
	int duration;
}
int start = 1;
int finish = 9;
{int} tasks = {1,2,3,4,5,6,7,8,9};
{Edge} adjList = {<1,2,0>,<1,3,0>,<2,4,7>,<2,5,7>,<3,5,9>,<4,7,12>,<5,6,8>,<6,7,9>,<6,8,9>,<8,9,5>,<7,9,6>};

dvar int earlyFinish[tasks];
dvar int earlyStart[tasks];

dvar int latestFinish[tasks];
dvar int latestStart[tasks];

dvar int slack[tasks];

minimize earlyFinish[finish] - earlyFinish[start];
subject to {
	//start et finish n'ont pas vraiment de earlyStart/latestStart/latestFinish 
	//donc ces conditions sont la pour éviter les valeurs infinies
	earlyFinish[start] == 0;
	earlyStart[start] == 0;
	latestFinish[finish] == earlyFinish[finish];
	latestStart[start] == 0;
	latestStart[finish]== earlyFinish[finish];
	earlyFinish[finish] == max(a in adjList : a.destination == finish) earlyFinish[a.origin];
	//slack = latest start - early start
	forall(t in tasks)
	  slack[t] == latestStart[t] - earlyStart[t];
	//forward pass
	forall(a in adjList)
		earlyStart[a.destination] - earlyStart[a.origin] >= a.duration;	
	forall(e in adjList)
		earlyFinish[e.origin] == earlyStart[e.origin] + e.duration;
	//backward pass
	forall(a in adjList :  a.origin != start)
		latestStart[a.origin] == latestFinish[a.origin] - a.duration;
	forall(e in adjList )
	  	latestFinish[e.origin] == min(i in adjList : i.origin == e.origin) latestStart[i.destination];

}
execute{
	write("Critical Path is ");
	for(i in tasks){
		if (slack[i] == 0 && i != finish){
			write(i+"-");		
		}	
	}
	write(i);
}
