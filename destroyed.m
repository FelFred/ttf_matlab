%close all
clear
clc

fileID = fopen('C:\destroyed.txt');
formatSpec = '%f %f %f'; %  1, time
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\destroyed0.txt');
formatSpec = '%f %f %f'; %  1, time
P_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);


length = length(P{1});
%fprintf('Array length = %d\n', length)


figure()
subplot(2,1,1)
plot(P{2}, P{1})
subplot(2,1,2)
plot(P{2}, P{3})
title('seq number of pkt loss, sv1');

fprintf('last lost seq c2 = %d\n', P{1}(end))

figure()
hist(P{1}, unique(P{1}));
title('loss hist, sv1')

disp('mode of sv1')
m1 = mode(P{1})
s1_idx = find(P{1}==m1)
%s1_idx(2)-s1_idx(1)



figure()
subplot(2,1,1)
plot(P_0{2}, P_0{1})
subplot(2,1,2)
plot(P_0{2}, P_0{3})
title('seq number of pkt loss, sv0');


fprintf('last lost seq c1 = %d\n', P_0{1}(end))

figure()
hist(P_0{1}, unique(P_0{1}));
title('loss hist, sv0')

disp('mode of sv0')
m0 = mode(P_0{1})
s0_idx = find(P_0{1}==m0)
%s0_idx(2)-s0_idx(1)



P{1}(end)
P_0{1}(end)


