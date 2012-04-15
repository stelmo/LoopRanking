function [out] = octbtest2x2(var1, var2)
%This program calculates and saves the local gains of btest2x2

%inputs
v1 = var1;
v2 = var2;
%the actual local gains [what will be investigated]
g13 = 12;
g14 = 1;
g23 = 1.5;
g24 = 11;

A = [g13, g23;g14, g24];
b = [v1;v2];

x = A*b;

%now need to organise output to match input for python
out = [v1;v2;x(1);x(2)];
end