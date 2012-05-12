% this script will just convert the dat file to a txt file
% this has been modified to give timed data

inputdata = load("statechangedata.dat");

inputdata1 = inputdata(1:25,:);
save -ascii controlcorrelationBROKEN1.txt inputdata1;

inputdata2 = inputdata(25:50,:);
save -ascii controlcorrelationBROKEN2.txt inputdata2;

inputdata3 = inputdata(1:100,:);
save -ascii controlcorrelationBROKEN3.txt inputdata3;

delete statechangedata.dat
delete timedata.dat

