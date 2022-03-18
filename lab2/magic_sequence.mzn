
int: N;

array [0..N-1] of var 0..N-1: magic;      

constraint forall(i in 0..N-1)
(magic[i] = sum([bool2int(magic[j] = i)| j in 0..N-1]));
 
solve satisfy;

output [ "magic sequence = ", show(magic),";\n"];
