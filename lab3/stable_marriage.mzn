include "globals.mzn";

% Parameters
int: n;
set of int: men = 1..n;
set of int: women = 1..n;
% Lower the rank is, the more preffered is the person
set of int: ranks = 1..n;
% Names, just for fun
array[men] of string: m_names;
array[women] of string: w_names;
% w_ranks[i,j] = how much i'th man is liked by the j'th woman, lowet the better
array[men, women] of ranks: w_ranks;
% m_ranks[i,j] = how much i'th woman is liked by the j'th man, lower the better
array[women, men] of ranks: m_ranks; 

% Variables
% wives[i] - zona itego mezczyzny
array[1..n] of var 1..n: wives; 
% husbands[i] - maz itej kobiety
array[1..n] of var 1..n: husbands; 

% Predicates
% Just to not care of the way preferences are encoded
predicate prefers_over(array[1..n, 1..n] of var 1..n: ranks, var 1..n: s, var 1..n: p1, var 1..n: p2) =
   ranks[p1, s] < ranks[p2, s];
   
predicate man_prefers_over(var men: m, var women: w1, var women: w2) = 
    prefers_over(m_ranks, m, w1, w2);

predicate woman_prefers_over(var women: w, var men: m1, var men: m2) = 
    prefers_over(w_ranks, w, m1, m2);

% Constraints
% 1) husband of a wife of 'm' is 'm'
% 2) wife of a husband of 'w' is 'w'
% 3) if man prefers other woman over his wife, then this other woman prefers her husband over him
% 4) if woman prefers other man over her husband, then this other man prefers his wife over her
constraint forall(i in 1..n)(husbands[wives[i]]=i);

constraint forall(i in 1..n)(wives[husbands[i]]=i);

constraint forall (i in 1..n,j in 1..n)
(if (man_prefers_over(i,j,wives[i])) then woman_prefers_over(j,husbands[j], i) endif);

constraint forall (i in 1..n,j in 1..n)
(if woman_prefers_over(i,j,husbands[i]) then (man_prefers_over(j,wives[j],i)) endif);


% Goal
solve satisfy;

% Output
output [show(m_names[m]) ++ " ♥ " ++ show(w_names[fix(wives[m])]) ++ "\n" | m in men];  