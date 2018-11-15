close all
clear
clc

fileID = fopen('C:\timeouts_c2.txt');
formatSpec = '%f %f'; %  1, time
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\timeouts_c1.txt');
formatSpec = '%f %f'; %  1, time
P_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

figure()
stem(P_0{2}, P_0{1})
title('Timeouts conexion 1')
xlabel('Tiempo [s]')
ylabel('Timeouts')

figure()
stem(P{2}, P{1})
title('Timeouts conexion 2')
xlabel('Tiempo [s]')
ylabel('Timeouts')






