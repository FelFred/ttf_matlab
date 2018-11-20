%close all
clear
clc
tic
%% Get simulation parameters from opnet written files

% Read parameters file
fileID = fopen('C:\params.txt');
cur_line = fgetl(fileID);
line_no = 1;
while ischar(cur_line)
    % Process current line
    switch line_no
        case 1
            % Algorithm name
            formatSpec = '%f';
            line_data = textscan(cur_line,formatSpec);
            alg_no = line_data{1};
            switch alg_no
                case 1
                    alg_name = 'DropTail';
                case 2
                    alg_name = 'RED';
                case 3
                    alg_name = 'TTF';
                otherwise
                    disp('wrong alg_no')
            end
        case 2
            % RTT per connection
            formatSpec = '%f %f';
            line_data = textscan(cur_line,formatSpec);
            rtt1 = line_data{1};
            rtt2 = line_data{2};
        case 3
            formatSpec = '%f';
            line_data = textscan(cur_line,formatSpec);
            p_intr = line_data{1};
        otherwise
            disp('no use for this line')
    end
     
    % Read next line
    cur_line = fgetl(fileID);
    line_no = line_no + 1;
end
fclose(fileID);

% FTP file size (bits)
fileID = fopen('C:\fsize_c1.txt');
formatSpec = '%f'; %  instancia, cwnd, time
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);
f_size = 8 * P{1};
%f_size = 8*200*10^6;

%% Read files

fileID = fopen('C:\begin_end_c2.txt');
formatSpec = '%f'; %  instancia, cwnd, time
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\begin_end_c1.txt');
formatSpec = '%f'; %  instancia, cwnd, time
P_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\loss_data.txt');
formatSpec = '%f'; %  instancia, cwnd, time
loss = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\total.txt');
formatSpec = '%f'; %  instancia, cwnd, time
total = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\cwndstat_c2.txt');
formatSpec = '%f %f'; %  cwnd, time
C = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\cwndstat_c1.txt');
formatSpec = '%f %f'; %  cwnd, time
C_0 = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

fileID = fopen('C:\qstats.txt');
formatSpec = '%f %f %f'; %  cwnd, time
Q = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

%% Get stats from data

% length = length(P{1});
% fprintf('Array length = %d\n', length)

% Connection duration
dt_c1 = P_0{1}(end) - P_0{1}(end-1)
dt_c2 = P{1}(end) - P{1}(end-1)

% Loss per connection
loss_c1 = loss{1}(1)+loss{1}(3)+loss{1}(5)
loss_c2 = loss{1}(2)+loss{1}(4)+loss{1}(6)
total_c1 = total{1}(1)
total_c2 = total{1}(2)
p1 = loss_c1/total_c1
p2 = loss_c2/total_c2

% Goodput per connection
goodput_simulado_c1 = f_size/dt_c1
goodput_simulado_c2 = f_size/dt_c2

% Throughout per connection
avg_cwnd_c1 = mean(C_0{1});
avg_cwnd_c2 = mean(C{1});
%plot(C{2}, C{1})  
th_sim_c1 = avg_cwnd_c1/rtt1;
th_sim_c2 = avg_cwnd_c2/rtt2;
fprintf('Avg cwnd c1 = %d, Avg throughput = %f\n', avg_cwnd_c1, th_sim_c1)
fprintf('Avg cwnd c2 = %d, Avg throughput = %f\n', avg_cwnd_c2, th_sim_c2)

% Theoretical throughout per connection
throughput_teo_c1 = 8*1500*(sqrt(3/(2*p1)))/rtt1
throughput_teo_c2 = 8*1500*(sqrt(3/(2*p2)))/rtt2

% Error between simulated throughput and theoretical throughput in percentage
error_c1 = abs(1- th_sim_c1/throughput_teo_c1)*100
error_c2 = abs(1- th_sim_c2/throughput_teo_c2)*100

% Error in the loss rate (simulation vs algorithm formula)
rate_error = abs(1-sqrt((loss_c1/loss_c2))/(rtt2/rtt1))*100

% Fairness plot stuff
x_array = [0 1];
x_array_2 = [0 1];
y_array_eff = [1 0];
y_array_fair = [0 1];

% Maximum theoretical throughputs
%p_intr = 0.001
max_th_c1 = 8*1500*(sqrt(3/(2*p_intr)))/rtt1
max_th_c2 = 8*1500*(sqrt(3/(2*p_intr)))/rtt2
rel_th_c1 = th_sim_c1/max_th_c1;
rel_th_c2 = th_sim_c2/max_th_c1;

%figure()
%plot(x_array, y_array_eff, '--')
%hold on
%plot(x_array_2, y_array_fair, '--r')
%plot(rel_th_c2, rel_th_c1, 'ko') % con normalizacion
plot(th_sim_c2, th_sim_c1, 'ko') % sin normalizacion


%% Save results in .mat file

f1 = 'alg';
f2 = 'rtts';
f3 = 'file_size';
f4 = 'cwnd';
f5 = 'conn_dur';
f6 = 'throughput';
f7 = 'goodput';
f8 = 'loss';
f9 = 'qstats';

rtt_cell = {{rtt1, rtt2}};
alg_cell = {{alg_name}};
fsize_cell = {{f_size}};
cwnd_cell = {{C, C_0}};
dt_cell = {{dt_c1, dt_c2}};
th_cell = {{th_sim_c1, th_sim_c2}};
gp_cell = {{goodput_simulado_c1, goodput_simulado_c2}};
loss_cell = {{p1, p2, p_intr}};
q_cell = {{Q{1}, Q{2}, Q{3}}};
results = struct(f1, alg_cell, f2, rtt_cell, f3, fsize_cell, f4, cwnd_cell, f5, dt_cell, f6, th_cell, f7, gp_cell, f8, loss_cell, f9, q_cell);
save('results.mat', 'results')

toc
