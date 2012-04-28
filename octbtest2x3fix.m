function [array] = octbtest2x3fix(var1, var2)

%inputs
v1 = var1;
v2 = var2;
%local gains
g13 = 12;
g24 = 5;
g35 = 1.1;
g45 = 1.25;

gd1 = 0.000001;
gd2 = 0.000003;
gd3 = 0.0000081;
gd4 = 0.0000054;

v3 = g13*v1;
v4 = g24*v2;
v5 = g35*v3+g45*v4;
d1 = gd1*v1;
d2 = gd2*v2;
d3 = gd3*v3;
d4 = gd4*v4;

array = [v1;v2;v3;v4;v5;d1;d2;d3;d4];


end