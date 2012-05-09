time = load("timedata.dat");
rchange = load("statechangedata.dat");

size(rchange)
rchange(end, :)'
plot(rchange(:,:))
pause(7)


