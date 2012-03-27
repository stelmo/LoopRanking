%script to change inputs one by one and generate the base case at i == 13

array = []; %empty set

for i=1:1:13

temp = octavedriver(i,20);
array = [array;-9999;temp];

endfor

save -ascii inputgains.txt array