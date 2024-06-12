#states
set S;

#action set for players
set A1{S};
set A2{S};

#rewards
param R1{s in S, a1 in A1[s], a2 in A2[s]};
param R2{s in S, a1 in A1[s], a2 in A2[s]};

#transition probabilities
param P{st in S , s in S , a1 in A1[s] , a2 in A2[s]};

#discounting factor
param beta = 0.75;

param K1 = ((max{s in S, a1 in A1[s] , a2 in A2[s]} R1[s,a1,a2])/(1-beta))
            - ((min{s in S, a1 in A1[s] , a2 in A2[s]} R1[s,a1,a2])/(1-beta));
param K2 = ((max{s in S, a1 in A1[s] , a2 in A2[s]} R2[s,a1,a2])/(1-beta))
          - ((min{s in S, a1 in A1[s] , a2 in A2[s]} R2[s,a1,a2])/(1-beta));




#strategy for players
var f{s in S, a1 in A1[s]} >= 0,<= 1;
var g{s in S, a2 in A2[s]} >= 0,<= 1;

#binary variables
var h1{s in S, a1 in A1[s]} binary;
var h2{s in S, a2 in A2[s]} binary;


#alpha variables
var alpha1{s in S, a1 in A1[s]};
var alpha2{s in S, a2 in A2[s]};

var v1{S};
var v2{S};

var T1{s in S , a1 in A1[s], a2 in A2[s]};
var T2{s in S , a1 in A1[s], a2 in A2[s]};


subject to T1_constraint{s in S, a1 in A1[s], a2 in A2[s]}:
    T1[s,a1,a2] = (sum{st in S} P[st, s, a1, a2]*v1[st]);

subject to T2_constraint{s in S , a1 in A1[s], a2 in A2[s]}:
    T2[s,a1,a2] = (sum{st in S} P[st, s, a1, a2]*v2[st]);

subject to f_constraint {s in S}:
    (sum{a1 in A1[s]} f[s, a1]) = 1;

subject to g_constraint {s in S}:
    (sum{a2 in A2[s]} g[s, a2]) = 1;

subject to v1_constraint{s in S, a1 in A1[s]}:
    v1[s] >= ((sum{a2 in A2[s]} R1[s,a1, a2]*g[s,a2]) 
    + beta*(sum{a2 in A2[s]} T1[s, a1,a2]*g[s,a2]));

subject to v2_constraint{s in S, a2 in A2[s]}:
    v2[s] >= ((sum{a1 in A1[s]} R2[s,a1, a2]*f[s,a1])
    + beta*(sum{a1 in A1[s]} T2[s, a1,a2]*f[s,a1]));


subject to f_binary_constraint{s in S, a1 in A1[s]}:
    f[s,a1] <= (1 - h1[s,a1]);

subject to g_binary_constraint{s in S, a2 in A2[s]}:
    g[s,a2] <= (1 - h2[s,a2]);


subject to alpha1_constraint1{s in S, a1 in A1[s]}:
    alpha1[s,a1] >= (v1[s] - (sum{a2 in A2[s]} R1[s,a1, a2]*g[s,a2]) 
    - beta*(sum{a2 in A2[s]} T1[s, a1,a2]*g[s,a2])) ;

subject to alpha2_constraint1{s in S, a2 in A2[s]}:
    alpha2[s,a2] >= (v2[s] - (sum{a1 in A1[s]} R2[s,a1, a2]*f[s,a1]) 
    - beta*(sum{a1 in A1[s]} T2[s, a1,a2]*f[s,a1])) ;

subject to alpha1_constraint2{s in S, a1 in A1[s]}:
    alpha1[s,a1] >= (K1*h1[s,a1]);

subject to alpha2_constraint2{s in S, a2 in A2[s]}:
    alpha2[s,a2] >= (K2*h2[s,a2]);

minimize obj:
    (sum{s in S , a1 in A1[s]} (alpha1[s,a1] - K1*h1[s,a1])) + 
    (sum{s in S, a2 in A2[s]} (alpha2[s,a2] - K2*h2[s,a2]));


