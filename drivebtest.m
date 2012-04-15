
ss = octbtest2x2(1,1);
ss1 = octbtest2x2(3, 1);
ss2 = octbtest2x2(1, 3.4);

ssb = octbtest2x3(1,1);
ss1b = octbtest2x3(3, 1);
ss2b = octbtest2x3(1, 3.4);

ssbfix = octbtest2x3fix(1,1);
ss1bfix = octbtest2x3fix(3, 1);
ss2bfix = octbtest2x3fix(1, 3.4);

array(:,1) = ss1;
array(:,2) = ss2;
array(:,3) = ss; %steady case
save -ascii "btest1ObviousConnections.txt" array

array = []; %just to be safe
array(:,1) = ss1b;
array(:,2) = ss2b;
array(:,3) = ssb; %steady case
save -ascii "btest2GreedyConnections.txt" array

array = [];
array(:,1) = ss1bfix;
array(:,2) = ss2bfix;
array(:,3) = ssbfix; %steady case
save -ascii "btest2GreedyConnectionsfix.txt" array

ssbrecfix = octbtest2x3recfix(2,2);

ss1brecfix = octbtest2x3recfix(3,2);
ss2brecfix = octbtest2x3recfix(2,3);

ss3brecfix = octbtest2x3recfix(3,5);
ss4brecfix = octbtest2x3recfix(5,3);

ss5brecfix = octbtest2x3recfix(5,7);
ss6brecfix = octbtest2x3recfix(7,5);

ss7brecfix = octbtest2x3recfix(11,7);
ss8brecfix = octbtest2x3recfix(7,11);

ss9brecfix = octbtest2x3recfix(11,13);
ss10brecfix = octbtest2x3recfix(13,11);

ss11brecfix = octbtest2x3recfix(17,13);
ss12brecfix = octbtest2x3recfix(13,17);

array = [];
array(:,1) = ss1brecfix;
array(:,2) = ss2brecfix;
array(:,3) = ss3brecfix;
array(:,4) = ss4brecfix;
array(:,5) = ss5brecfix;
array(:,6) = ss6brecfix;
array(:,7) = ss7brecfix;
array(:,8) = ss8brecfix;
array(:,9) = ss9brecfix;
array(:,10) = ss10brecfix;
array(:,11) = ss11brecfix;
array(:,12) = ss12brecfix;

array(:,13) = ssbrecfix; %steady case
smallarray(:,1) = array(:,1);
smallarray(:,2) = array(:,2);
smallarray(:,3) = array(:,13);
save -ascii "btest3.txt" array
save -ascii "btest3fix.txt" smallarray