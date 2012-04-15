function [array] = formattest1(var1, var2, var3)

v1 = var1;
v2 = var2;
v3 = var3;

v4 = v1;
v5 = v2;
v6 = v3;

g47 = 3;
g58 = 3.9;
g68 = 4.2;
g89 = 6.9;
g79 = 7.7;

v7 = g47*v4;
v8 = g58*v5 + g68*v6;
v9 = g79*v7 + g89*v8;


array = [v1;v2;v3;v4;v5;v6;v7;v8;v9];

end