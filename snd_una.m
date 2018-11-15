%close all
clear
clc

fileID = fopen('C:\snd_una.txt');
formatSpec = '%f %f'; %  instancia, pipe, time
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\snd_una_0.txt');
formatSpec = '%f %f'; %  instancia, pipe, time
P_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);


length = length(P{1});
fprintf('Array length = %d\n', length)

figure()
plot(P{2}, P{1})

figure()
plot(P_0{2}, P_0{1})


% xlabel('Tiempo[s]')
% ylabel('Paquetes[bytes]')
% title('cwnd vs tiempo, server 1')

% figure()
% plot(P{4}, P{2})
% xlabel('Tiempo[s]')
% ylabel('Paquetes[bytes]')
% title('pipe vs tiempo, server 1')
% 
% figure()
% plot(P{4}, P{1}, 'r')
% xlabel('Tiempo[s]')
% ylabel('Paquetes[bytes]')
% title('cwnd y pipe vs tiempo, server 1')
% hold on
% plot(P{4}, P{2}, 'k')
% 
% 
% 
% figure()
% plot(P_0{4}, P_0{1})
% xlabel('Tiempo[s]')
% ylabel('Paquetes[bytes]')
% title('cwnd vs tiempo, server 0')
% 
% figure()
% plot(P_0{4}, P_0{2})
% xlabel('Tiempo[s]')
% ylabel('Paquetes[bytes]')
% title('pipe vs tiempo, server 0')
% 
% figure()
% plot(P_0{4}, P_0{1}, 'r')
% xlabel('Tiempo[s]')
% ylabel('Paquetes[bytes]')
% title('cwnd y pipe vs tiempo, server 0')
% hold on
% plot(P_0{4}, P_0{2}, 'k')
% 
% 
