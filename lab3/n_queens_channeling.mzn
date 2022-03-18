include "alldifferent.mzn";
include "lex_lesseq.mzn";

int: N;
set of int: indexes = 1..N;

array[indexes] of var indexes: rows;
array[1..N, 1..N] of var bool: qb;

%symetrie
array[int] of var bool: id = array1d(qb);
array[int] of var bool: s1 = [ qb[i,j] | i in reverse(1..N), j in 1..N ];
array[int] of var bool: s2 = [ qb[i,j] | i in 1..N, j in reverse(1..N) ];
array[int] of var bool: s3 = [ qb[i,j] | i,j in reverse(1..N) ];
array[int] of var bool: s4 = [ qb[j,i] | i,j in 1..N ];
array[int] of var bool: s5 = [ qb[j,i] | i in reverse(1..N), j in 1..N ];
array[int] of var bool: s6 = [ qb[j,i] | i in 1..N, j in reverse(1..N) ];
array[int] of var bool: s7 = [ qb[j,i] | i,j in reverse(1..N) ];

constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in indexes]);
constraint alldifferent([rows[i] - i | i in indexes]);

%powiazanie ograniczen
constraint forall(i in 1..N, j in 1..N) 
(qb[i,j] <-> rows[i]=j);

%wykluczam symetrie
constraint lex_lesseq(id, s1); 
constraint lex_lesseq(id, s2); 
constraint lex_lesseq(id, s3); 
constraint lex_lesseq(id, s4); 
constraint lex_lesseq(id, s5); 
constraint lex_lesseq(id, s6); 
constraint lex_lesseq(id, s7); 

solve satisfy; 
  
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];