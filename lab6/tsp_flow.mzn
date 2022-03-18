include "globals.mzn";

int: Nodes;
set of int: NUM = 1..Nodes;
array[NUM,NUM] of int: Dist;
%y,x
array[NUM,NUM] of var bool: flow;
array[NUM,NUM] of var 0..Nodes-1: visit_counter;

var int: total_distance;


%  1) total flow coming from every node should be equal 1
constraint forall(i in NUM)(sum(j in NUM)(flow[i,j]) = 1); 
%  2) total flow going into every node should be equal 1
constraint forall(i in NUM)(sum(j in NUM)(flow[j,i]) = 1); 
%b) visit_counter related
%  1) visit counter for edges originating from the first node is 0
constraint forall(i in NUM)(visit_counter[1,i] = 0);
%  2) visit counter for inactive edges should be equal 0
constraint forall(i in NUM,j in NUM)(visit_counter[i,j] <= flow[i,j]*(Nodes-1));
%  3) total* visit counter for edges ending at the first node should equal Nodes - 1
constraint sum(i in NUM)(visit_counter[i,1]) = Nodes-1;
%  4) total* visit counter for "normal" edges should be higher by 1 compared to the previous* edges
constraint forall(i in 2..Nodes)(sum(j in NUM)(visit_counter[i,j])-sum(j in NUM)(visit_counter[j,i]) = 1);

total_distance = sum(i in NUM, j in NUM where flow[i,j] = 1)(Dist[i,j]);

solve minimize total_distance;
 
output ["total distance: \(total_distance)\n"] ++
       [if fix(flow[i,j]) then " -> \(j)" else "" endif | i, j in NUM];
