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
int start = ...;
int finish = ...;
{int} tasks = ...;
{Edge} adjList =...;
int nbteams =...;
int teams[tasks]=...;

//les variables nécessaires pour chaque tache
dvar int earlyFinish[tasks];
dvar int earlyStart[tasks];

dvar int latestFinish[tasks];
dvar int latestStart[tasks];

dexpr int slack[t in tasks] =latestStart[t] - earlyStart[t];

//fonction objectif : minimiser le temps total du projet
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
	forall(t in tasks)
	  0 <= slack[t];
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
    //print du chemin critique
	write("Critical Tasks is ");
	for(var i in tasks){
		if (slack[i] == 0 && i != finish && i!=start){
			write(i+" ");		
		}	
	}
	write(i);
}

