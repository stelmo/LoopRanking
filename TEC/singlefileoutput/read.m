time = load("timedata.dat");
rchange = load("statechangedata.dat");
%good = load("good.dat");

size(rchange)

arr(:,1) = rchange(1,:)';
arr(:,2) = rchange(end,:)';

arr

figure(1)
plot(time, rchange(:,11))
pause(10)
% % 
% % figure(2)
% % plot(time, good(:,11))




%size(good)

%diff = good(450:900, 11) - rchange(450:900, 11)


%rchange(1:1:10,1:1:12)

