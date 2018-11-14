%close all
clear
clc

fileID = fopen('C:\cwnd_update.txt');
formatSpec = '%f %f'; %  1, time
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\cwnd_update_0.txt');
formatSpec = '%f %f'; %  1, time
P_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

length = length(P{1});
fprintf('Array length = %d\n', length)

figure()
plot(P{2}, P{1}, 'bx')

figure()
plot(P_0{2}, P_0{1}, 'bx')





