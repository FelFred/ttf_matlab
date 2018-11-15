%close all
clear
clc

fileID = fopen('C:\tcpack.txt');
formatSpec = '%f %f %f %f %f %f %f %f %f'; %  1, time
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\tcpack_0.txt');
formatSpec = '%f %f %f %f %f %f %f %f %f'; %  1, time
P_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\tcpack2.txt');
formatSpec = '%f %f %f %f %f %f %f'; %  1, time
P2 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\tcpack2_0.txt');
formatSpec = '%f %f %f %f %f %f %f'; %  1, time
P2_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

length = length(P{1});
fprintf('Array length = %d\n', length)

figure()
subplot(4,1,1)
plot(P{9}, P{1}, 'bx')
subplot(4,1,2)
plot(P{9}, P{2}, 'bx')
subplot(4,1,3)
plot(P{9}, P{3}, 'bx')
subplot(4,1,4)
plot(P{9}, P{4}, 'bx')

figure()
plot(P{9}, P{5})
title('seg ack');

figure()
plot(P{9}, P{6})
title('seg una');

figure()
plot(P{9}, P{7})
title('seg max');

figure()
plot(P{9}, P{8})
title('seg nxt');

figure()
plot(P{9}, P{7}-P{6})
title('snd max - snd una');

figure
plot(P{9}, P{5}-P{6})
title('seg ack - snd una');

figure()
plot(P2{6}, P2{1}, 'bx')
title('bool 4, parte 2')

figure()
plot(P2{6}, P2{2})
title('seg ack, parte 2')

figure()
plot(P2{6}, P2{7})
title('seg ack (sv), parte 2')

figure()
plot(P2{6}, P2{3})
title('snd una, parte 2')

figure()
plot(P2{6}, P2{4})
title('snd max, parte 2')

figure()
plot(P2{6}, P2{5})
title('snd nxt, parte 2')

figure()
plot(P2{6}, P2{2}-P2{3})
title('seg ack - snd una, parte 2')

figure()
plot(P2{6}, P2{4}-P2{3})
title('snd max - snd una, parte 2')

% figure()
% subplot(4,1,1)
% plot(P_0{9}, P_0{1}, 'bx')
% subplot(4,1,2)
% plot(P_0{9}, P_0{2}, 'bx')
% subplot(4,1,3)
% plot(P{9}, P{3}, 'bx')
% subplot(4,1,4)
% plot(P{9}, P{4}, 'bx')

figure()
plot(P_0{9}, P_0{5})
title('seg ack');

figure()
plot(P_0{9}, P_0{6})
title('seg una');

figure()
plot(P_0{9}, P_0{7})
title('seg max');

figure()
plot(P_0{9}, P_0{8})
title('seg nxt');

figure()
plot(P_0{9}, P_0{7}-P_0{6})
title('snd max - snd una');

figure
plot(P_0{9}, P_0{5}-P_0{6})
title('seg ack - snd una');







% figure()
% plot(P_0{2}, P_0{1}, 'bx')





