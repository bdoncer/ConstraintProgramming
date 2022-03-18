include "diffn.mzn";
include "cumulative.mzn";

int: n;                     
set of int: SQUARES = 1..n; 
int: min = n;
int: max = sum([i | i in SQUARES]);
array[SQUARES] of int: sq = [i|i in SQUARES];

var min..max: height;    
var min..max: width;    
var sum([i*i | i in SQUARES])..(max*max): area = height * width; 
array[SQUARES] of var 0..(max-1): x; 
array[SQUARES] of var 0..(max-1): y;

% Constraint 1: Squares should fit inside the container
constraint forall (i in SQUARES)(
x[i]+i<=width /\ y[i]+i<=height
);
 
% Constraint 2: Squares should not overlap
%constraint forall (i,j in SQUARES where i != j)(
%x[i]+i<=x[j] \/ x[j]+j<=x[i] \/ y[j]+j<=y[i] \/ y[i]+i<=y[j]
%);
constraint diffn(x,y,sq,sq);

% Constraint 3: Symetry breaking
constraint width >= height;

%Redundant
constraint cumulative(
            [ x[i] | i in SQUARES],
            [   i  | i in SQUARES],
            [   i  | i in SQUARES],
            height
        );

constraint cumulative(
            [ y[i] | i in SQUARES],
            [   i  | i in SQUARES],
            [   i  | i in SQUARES],
            width
        );
        
        
solve :: seq_search([
             int_search([ area, height ], input_order, indomain_min, complete),
             int_search([ y[n + 1 - i] | i in SQUARES]
          ++ [ x[n + 1 - i] | i in SQUARES], input_order, indomain_min)])
      minimize area;


output [ show(i) ++ " > (" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")\n" | i in 1..n] ++
  ["area = " ++ show(width) ++ " * " ++ show(height) ++ " = " ++ show(area)];
