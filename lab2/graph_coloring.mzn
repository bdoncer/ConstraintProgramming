int: nodesNumber;
array[1..nodesNumber,1..nodesNumber] of int: edges;

 array[1..nodesNumber] of var 1..nodesNumber: nodes;
 var int: colorsNumber;

constraint forall(i,j in 1..nodesNumber)
(if edges[i,j] == true then nodes[i] != nodes[j] else true endif);

colorsNumber = max(nodes);
solve minimize colorsNumber;

output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber]
