close all
clear
clc

%% Read file
fileID = fopen('C:\snd_dsize_c2.txt');
formatSpec = '%f %f %f %f %f %f'; % snd_dsize, avail_wnd, cwnd, snd_una, snd_nxt, time
P11 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\snd_dsize2_c2.txt');
formatSpec = '%f %f'; % time, snd_buf_size
P12 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\snd_dsize_c1.txt');
formatSpec = '%f %f %f %f %f %f'; % snd_dsize, avail_wnd, cwnd, snd_una, snd_nxt, time
P21 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\snd_dsize2_c1.txt');
formatSpec = '%f %f'; % time, snd_buf_size
P22 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

main_length = length(P11{1});
fprintf('Array length = %d\n', main_length)



%% Plots

figure()
plot(P11{6}, P11{1})
title('snd data size');

figure()
plot(P11{6}, P11{2})
title('avail wnd');

figure()
plot(P11{6}, P11{3})
title('cwnd');

figure()
plot(P11{6}, P11{4})
title('snd una');

figure
plot(P11{6}, P11{5})
title('snd next');

fprintf('last seq c2 = %d\n', P11{5}(end))

figure
plot(P12{1}, P12{2})
title('snd buf size');


figure()
plot(P21{6}, P21{1})
title('snd data size');

figure()
plot(P21{6}, P21{2})
title('avail wnd');

figure()
plot(P21{6}, P21{3})
title('cwnd');

figure()
plot(P21{6}, P21{4})
title('snd una');

figure
plot(P21{6}, P21{5})
title('snd next');

fprintf('last seq c1 = %d\n', P21{5}(end))

figure
plot(P22{1}, P22{2})
title('snd buf size');

