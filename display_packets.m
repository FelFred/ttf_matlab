close all
clear
clc

% intmax('uint64')
fileID = fopen('C:\packets.txt');
formatSpec = '%f %f %f %f'; %  in/out, port, time, pkt*service_time, data_len
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

max_disp_pkts = 3000; %20000
pkts = length(P{1});

disp_pkts = min(max_disp_pkts, pkts);
fprintf('The total packets are %d, displaying %d packets\n', pkts, disp_pkts)

packets_y_in = 0;
packets_y_out = 1;
height = 0.9;
offset = 0.05;

% plot([0 1], [0 0], 'k')

pkt_color_1 = 'bc';
pkt_color_2 = 'ry';
for n = 9:disp_pkts
    if P{2}(n) == 1
        if P{1}(n) == 1
            rectangle('Position', [P{3}(n), P{1}(n)*packets_y_out, P{4}(n), height], 'FaceColor', pkt_color_1(1), 'EdgeColor', pkt_color_1(2));
        else
            rectangle('Position', [P{3}(n), P{1}(n)*packets_y_out, P{4}(n), height], 'FaceColor', pkt_color_1(1), 'EdgeColor', pkt_color_1(2));
        end
        
    else
        if P{1}(n) == 1
            rectangle('Position', [P{3}(n), P{1}(n)*packets_y_out+offset, P{4}(n), height], 'FaceColor', pkt_color_2(1), 'EdgeColor', pkt_color_2(2));
        else
            rectangle('Position', [P{3}(n), P{1}(n)*packets_y_out+offset, P{4}(n), height], 'FaceColor', pkt_color_2(1), 'EdgeColor', pkt_color_2(2));
        end
        
    end        
end
axis([P{3}(9) P{3}(disp_pkts)+P{4}(disp_pkts) 0 2])