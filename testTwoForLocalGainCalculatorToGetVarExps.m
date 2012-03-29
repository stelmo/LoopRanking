%solve the system of equations

%inputs
V1 = 1
V2 = 2
V3 = 1

A = [1 0 -13 0;-5 1 0 0;-7 0 1 -23;0 -17 -19 1];
b = [V2;2*V1;3*V3;0];
x = A\b