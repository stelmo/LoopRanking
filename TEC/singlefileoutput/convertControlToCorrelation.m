% this script will just convert the dat file to a txt file
% this has been modified to give timed data

inputdata = load("statechangedata.dat");
inputdata = inputdata(80:120,:);
save -ascii controlcorrelationBROKEN3.txt inputdata;
delete statechangedata.dat
delete timedata.dat

