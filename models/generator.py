import random
import sys
#N -> number of states
N = int(sys.argv[1])

# Define the range for the parameters
p_min = 1
p_max = 4
r_min = 0
r_max = 500

# Generate random values for P, R1, and R2
S = set(range(1, N + 1))
A1 = {s: set(range(1, random.randint(1,5) + 1)) for s in S}
A2 = {s: set(range(1, random.randint(1,5) + 1)) for s in S}
P = dict()
for s in S:
    for a1 in A1[s]:
        for a2 in A2[s]:
            sum_probabilities = 0
            while (sum_probabilities != 10):
                Q = {(s_, s, a1, a2): random.randint(p_min, p_max) for s_ in S}
                sum_probabilities = sum(Q[s_, s, a1, a2] for s_ in S)
                P.update({key : value/sum_probabilities for key, value in Q.items()})


R1 = {(s, a1, a2): random.randint(r_min, r_max) for s in S for a1 in A1[s] for a2 in A2[s]}
R2 = {(s, a1, a2): random.randint(r_min, r_max) for s in S for a1 in A1[s] for a2 in A2[s]}

# Write the data to a file
with open(f'{N}stdata.dat', 'w') as data_file:
    data_file.write(f"set S := {', '.join(map(str, S))};\n")
    for s in S:
        data_file.write(f"set A1[{s}] := {', '.join(map(str, A1[s]))};\n")
        data_file.write(f"set A2[{s}] := {', '.join(map(str, A2[s]))};\n")
    
    data_file.write("param P := ")
    for (s_, s, a1, a2) in P:
        data_file.write(f"\n  {s_} {s} {a1} {a2} {P[s_, s, a1, a2]}")
    data_file.write(";\n")

    data_file.write("param R1 := ")
    for (s, a1, a2) in R1:
        data_file.write(f"\n  {s} {a1} {a2} {R1[s, a1, a2]}")
    data_file.write(";\n")

    data_file.write("param R2 := ")
    for (s, a1, a2) in R2:
        data_file.write(f"\n  {s} {a1} {a2} {R2[s, a1, a2]}")
    data_file.write(";\n")
