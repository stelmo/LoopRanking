time = load("timedata.dat");
rchange = load("statechangedata.dat");

figure(1)
plot(time, rchange(:,11))

% figure(2)
% plot(time, nchange(:,:))
pause(10)

rchange(:,11:1:15)

