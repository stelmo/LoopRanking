%step the controlled variables

array(:,1) = getvart4(1*1.25, 2, 3, 5);
array(:,2) = getvart4(1, 2*1.25, 3, 5);
array(:,3) = getvart4(1, 2, 3*1.25, 5);
array(:,4) = getvart4(1, 2, 3, 5*1.25);

array(:,5) = getvart4(1,2,3,5); %"steady state"

save -ascii controlledTestFour.txt array