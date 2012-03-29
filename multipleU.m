%%script to change inputs one by one and generate the base case at i == 13

array = []; %empty array

for i=1:1:13
[temp,temp2] = octavedriver(i,45);
array(1:1:5,i) = temp(1:1:5,1);
array(6,i) = temp2(9+20,1);
array(7,i) = temp2(10+20,1);
array(8,i) = temp2(11+20,1);
array(9,i) = temp2(12+20,1);
array(10:1:45,i) = temp(6:1:end,1); 
%the 4 extra "variables" included here are inputs not measured. these are now included to calculate all the gains
%the reason for the strange order of appending them is because of the layout of the connection csv file... 
%this just keeps the variables consistent ito referencing
end
 
save -ascii inputgains.txt array