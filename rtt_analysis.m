clear all
close all
clc

%%
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\est0.txt');
formatSpec = '%f %f %f';
Rc1 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

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

fileID = fopen('C:\reset_c2.txt');
formatSpec = '%f %f'; %  state, Up-down/0-1, time
rst = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\reset_c1.txt');
formatSpec = '%f %f'; %  state, Up-down/0-1, time
rst_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\\rtt_cnt2.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
C = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\\rtt_cnt1.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
C_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\\ret_c2.txt');
formatSpec = '%f %f'; %  state, Up-down/0-1, time
ret = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\\ret_c1.txt');
formatSpec = '%f %f'; %  state, Up-down/0-1, time
ret_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

figure()
subplot(2,1,1)
plot(Rc1{2}, Rc1{1})
subplot(2,1,2)
plot(Rc1{2}, Rc1{3})


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
hold on
plot(E3_1{3}, E3_1{1}, 'r')

figure()
plot(rst_0{2}, rst_0{1})

figure()
plot(C_0{3}, C_0{1})

figure()
plot(ret_0{2}, ret_0{1})