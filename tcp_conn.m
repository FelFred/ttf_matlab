close all
clear
clc

fileID = fopen('C:\tcp_conn_trace.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\tcp_conn_trace_0.txt');
formatSpec = '%f %f %f'; %  state, Up-down/0-1, time
P_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

length = length(P{1});
fprintf('Array length = %d\n', length)

figure()
subplot(2,1,1)
plot(P{3}, P{1})
subplot(2,1,2)
plot(P{3}, P{2})

figure()
subplot(2,1,1)
plot(P_0{3}, P_0{1})
subplot(2,1,2)
plot(P_0{3}, P_0{2})




