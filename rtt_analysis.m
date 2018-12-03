fileID = fopen('C:\search1_c2.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
E1_2 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\search1_c1.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
E1_1 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\search2_c2.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
E2_2 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\search2_c1.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
E2_1 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\search3_c2.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
E3_2 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\search3_c1.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
E3_1 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\rcv_c2.txt');
formatSpec = '%f %f'; %  state, Up-down/0-1, time
R = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\rcv_c1.txt');
formatSpec = '%f %f'; %  state, Up-down/0-1, time
R_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

figure()
plot(E1_1{3}, E1_1{2})
hold on
plot(E2_1{3}, E2_1{2})
plot(E3_1{3}, E3_1{2})
hold off

figure()
plot(E1_2{3}, E1_2{2})
hold on
plot(E2_2{3}, E2_2{2})
plot(E3_2{3}, E3_2{2})
hold off

figure()
plot(R_0{2}, R_0{1})
