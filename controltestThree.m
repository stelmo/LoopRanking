%"step" controlled variables

array(:,1) = getvart3(2*1.25, 3, 7);
array(:,2) = getvart3(2, 3*1.25, 7);
array(:,3) = getvart3(2, 3, 7*1.25);

array(:,4) = getvart3(2, 3, 7); %steady state

save -ascii controlledTestThree.txt array




