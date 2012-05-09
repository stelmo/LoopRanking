time = load("timedata.dat");
rchange = load("statechangedata.dat");

size(rchange)
arr(:,1) = rchange(1, :)';
arr(:,2) = rchange(end, :)';
arr


plot(rchange(:,26:29))
pause(7)


