% parameters
int: minColorsNumber;
int: nodesNumber;
array [1..nodesNumber, 1..nodesNumber] of bool: edges;
array [1..minColorsNumber] of int: maxClique;
 
% decision variables
var 1..nodesNumber: colorsNumber;
array [1..nodesNumber] of var 1..nodesNumber: nodes;

% constraints
constraint colorsNumber >= minColorsNumber;
constraint colorsNumber = max(nodes);

constraint forall (i,j in 1..nodesNumber where i < j /\ edges[i,j])(
  nodes[i] != nodes[j]
);
constraint forall(i in 1..minColorsNumber) (nodes[maxClique[i]]=i);

% goal
solve minimize colorsNumber;

% output
output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber]