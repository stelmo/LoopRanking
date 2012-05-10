time = load("timedata.dat");
rchange = load("statechangedata.dat");

size(rchange)
arr(:,1) = rchange(1, :)';
arr(:,2) = rchange(end, :)';
arr


plot(rchange(:,1:12))
pause(5)

delete statechangedata.dat
delete timedata.dat

