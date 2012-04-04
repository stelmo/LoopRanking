%%script to change inputs one by one and generate the base case at i == 13.

array = []; %empty array

for i=1:1:13
[out, in] = octavedriver(i,5);

array(1:1:12,i) = in(21:1:end,1);
array(13:1:49,i) = out(5:1:end,1);

end
 
save -ascii statesinputstep005h5.txt array