include "diffn.mzn";
include "cumulative.mzn";

int: nr; % number of reclaimers
           % number of rails = nr for stages A,B,C,D,E
           % number of rails = (nr + 1) div 2 for stage F
set of int: RECLAIMER = 1..nr;
bool: stageF; % is this stage F data

int: ns; % number of stockpiles
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size in 10000 tonnes
array[STOCKPILE] of SHIP: ship; % which ship carries stockpile
int: maxtime; % time considered
set of int: TIME = 0..maxtime;
int: nsh; % number of ships
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when ship arrives in port

int: len; % length of pad
set of int: POSITION = 0..len;

int: stack_time; % stack time per unit of coal
int: reclaim_time; % recliaim time per unit of coal
int: reclaim_speed; %


array[STOCKPILE] of var POSITION: westend;  % Start pos of stack
array[STOCKPILE] of var POSITION: eastend;  % End position of stack
array[STOCKPILE] of var TIME: stack;        % Time of stack start
array[STOCKPILE] of var TIME: endstack;     % Time of stack end
array[STOCKPILE] of var TIME: reclaim;      % Time of reclaim start
array[STOCKPILE] of var TIME: finished;     % Time of reclaim 
array[STOCKPILE] of var RECLAIMER: which;   % Which reclaimer for given stockpile

array[STOCKPILE] of var TIME: piletimes;
constraint forall(i in STOCKPILE)(endstack[i] = stack[i] + stack_time*size[i]);
constraint forall(i in STOCKPILE)(finished[i] >= stack[i] + stack_time*size[i] + reclaim_time*size[i]);
constraint forall(i in STOCKPILE)(reclaim[i] = endstack[i]);
constraint forall(i in STOCKPILE)(finished[i] = reclaim[i] + reclaim_time*size[i]);
constraint forall(i in STOCKPILE) (eastend[i] = westend[i]+size[i]);

constraint forall(i in STOCKPILE)(piletimes[i] = finished[i]-stack[i]);
constraint diffn(stack,westend,piletimes,size);
constraint cumulative(stack, piletimes, size, len);
constraint cumulative(westend, size, piletimes, maxtime);
predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2, var int:distance) =
     finished[s1]+distance*reclaim_speed <= reclaim[s2] 
  \/ finished[s2]+distance*reclaim_speed <= reclaim[s1];


constraint forall(i in STOCKPILE)(reclaim[i] >= arrival[ship[i]]);
constraint forall(i,j in STOCKPILE where ship[i]==ship[j] /\ i!=j)(not_overlap(i,j,0));
constraint forall(i,j in STOCKPILE where which[i]==which[j] /\ i!=j)(not_overlap(i,j,abs(westend[i]-westend[j])));


array[RECLAIMER, TIME] of var POSITION: posHist;
constraint if stageF then forall(i in STOCKPILE, t in reclaim[i]..finished[i]) (posHist[which[i],t] = westend[i]) endif;
constraint if stageF then forall(i in TIME, j in RECLAIMER where (j mod 2) == 0)(posHist[j-1,i] <= posHist[j,i]) endif;


var int: obj = sum([max([finished[j]-arrival[i] | j in STOCKPILE where ship[j] == i]) | i in SHIP ]);

solve::int_search(reclaim, first_fail, indomain_min) minimize obj;



output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"] ++
["obj = ",show(obj), ";\n"]
;
