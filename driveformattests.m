
test1step1 = formattest1(2,1,1);
test1step2 = formattest1(1,2,1);
test1step3 = formattest1(1,1,2);

test1step11 = formattest1(3,2,1);
test1step22 = formattest1(1,3,2);
test1step33 = formattest1(2,1,3);

test1step111 = formattest1(5,1,1);
test1step222 = formattest1(1,5,1);
test1step333 = formattest1(1,1,5);

test1steady = formattest1(1,1,1);

statearray(:,1) = test1step1;
statearray(:,2) = test1step2;
statearray(:,3) = test1step3;

statearray(:,4) = test1step11;
statearray(:,5) = test1step22;
statearray(:,6) = test1step33;

statearray(:,7) = test1step111;
statearray(:,8) = test1step222;
statearray(:,9) = test1step333;

statearray(:,10) = test1steady;

save -ascii "formattest1.txt" statearray