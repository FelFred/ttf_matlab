%close all
clear
clc

fileID = fopen('C:\destroyed_data.txt');
formatSpec = '%f %f %f %f'; % port, fields_tcp->seq_num, op_sim_time(), outcome
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

L = length(P{1});
%fprintf('Array length = %d\n', L)
total_c0 = 0;
total_c1 = 0;

for (i = 1:L)
    if (P{1}(i) == 1)
        total_c0 = total_c0 + 1;
    elseif (P{1}(i) == 3)
        total_c1 = total_c1 + 1;
    end
end

c1_data = zeros(total_c0, 3);
c2_data = zeros(total_c1, 3);
c1_idx = 1;
c2_idx = 1;

for (i = 1:L)
    if (P{1}(i) == 1)
        c1_data(c1_idx,:) = [P{2}(i) P{3}(i) P{4}(i)]';
        c1_idx = c1_idx + 1;
    elseif (P{1}(i) == 3)
        c2_data(c2_idx,:) = [P{2}(i) P{3}(i) P{4}(i)]';
        c2_idx = c2_idx + 1;
    end
end


figure()
subplot(2,1,1)
plot(c2_data(:,2), c2_data(:,1))
subplot(2,1,2)
plot(c2_data(:,2), c2_data(:,3))
title('seq number of pkt loss, sv1');

figure()
hist(c2_data(:,1), unique(c2_data(:,1)));
title('loss hist, sv1')

disp('mode of sv1')
m1 = mode(c2_data(:,1))
s1_idx = find(c2_data(:,1)==m1)
%s1_idx(2)-s1_idx(1)



figure()
subplot(2,1,1)
plot(c1_data(:,2), c1_data(:,1))
subplot(2,1,2)
plot(c1_data(:,2), c1_data(:,3))
title('seq number of pkt loss, sv0');

figure()
hist(c1_data(:,1), unique(c1_data(:,1)));
title('loss hist, sv0')

disp('mode of sv0')
m0 = mode(c1_data(:,1))
s0_idx = find(c1_data(:,1)==m0)
%s0_idx(2)-s0_idx(1)






