int: N;

array[1..N] of var 1..N: rows;

constraint forall([i == j \/ rows[i] != rows[j] | i in 1..N,j in 1..N]);
constraint forall([i == j \/ rows[i]+i != rows[j]+j | i in 1..N,j in 1..N]);
constraint forall([i == j \/ rows[i]-i != rows[j]-j | i in 1..N,j in 1..N]);

solve satisfy; 
  
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];