% this script should add averaged end values to a txt file

inputdata = load("statechangedata.dat");

inputdata = inputdata(80:120, :);

delete statechangedata.dat
delete timedata.dat

%house keeping done
%For the local gains you will only really be interested in
%the final, "steady" averages...

%take the last 50 data points and calculate their average
[r, c] = size(inputdata);

for i=1:c
	total = sum(inputdata(:, i));
	array(i, 1) = total/40;
endfor

[infor, err, msg] = stat("localaveBROKEN3.txt");

if (err == -1) %if the file does not exist
temp = [];
save -ascii localaveBROKEN3.txt temp;  %create an empty file
[infor, err, msg] = stat("localaveBROKEN3.txt");
end

flag = infor.size;

if (flag != 0) %i.e. it has some data in it already

initial = load("localaveBROKEN3.txt");
[r, c] = size(initial);
delete("localaveBROKEN3.txt");


%This method adds the new data to the front of the file matrix
for i=1:1:c
array(:,1+i) = initial(:,i);
end

save -ascii localaveBROKEN3.txt array
else

save -ascii localaveBROKEN3.txt array

end
