function [array] = octbtest2x3(var1, var2)

%inputs
v1 = var1;
v2 = var2;
%local gains
g13 = 12;
g24 = 5;
g35 = 1.1;
g45 = 1.25;

v3 = g13*v1;
v4 = g24*v2;
v5 = g35*v3+g45*v4;

array = [v1;v2;v3;v4;v5];


end