/*********************************************
 * OPL 12.10.0.0 Model
 * Author: HP
 * Creation Date: 15 juin 2020 at 14:24:21
 *********************************************/
 using CP;

int len = ...;

range slackVectorRange = 0..len;
int slackVector[slackVectorRange] =...;

dvar int addedSlack[slackVectorRange];

subject to {
  //la marge ajouté ne peux pas dépasser la marge totale.
	forall(t in slackVectorRange)
	  addedSlack[t] <= slackVector[t] && addedSlack[t] >=0;
	  
}
main{
	
}