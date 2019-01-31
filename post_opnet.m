% This file transforms .txt data to a struct

%close all
clear
clc
tic

%% Set path of opnet_res folder
user_path = 'C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\'; 
% FF desktop: 'C:\\D\\Sefe\\Universidad\\opnet\\opnet_res\\'
% FF note - 'C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\'

%% Create folder with current date and time
date_time = datetime('now');
DateString = datestr(date_time);
DateStr = strrep(DateString,' ','_');
dirStr = strrep(DateStr,':','-');
mkdir('./resultados/', dirStr);


%% Define structure format (fields)

f1 = 'alg';                                      
f2 = 'rtts';
f3 = 'bg_dist';
f4 = 'file_size';
f5 = 'cwnd';
f6 = 'conn_dur';
f7 = 'throughput';
f8 = 'goodput';
f9 = 'loss';
f10 = 'qstats';
f11 = 'rtt_est';
f12 = 'th_eff';
f13 = 'timeouts';
f14 = 'red_params';
f15 = 'loss_pdf';
f16 = 'dest';
f17 = 'bg';

%% Determine number of simulations based on delimiters in params file

params_text = fileread(strcat(user_path,'params.txt'));
delim = strcat('newdata', char(13), char(10)); % ASCII: 13 = \r , carriage return, 10 = \n , line feed
n_sim = length(strfind(params_text,delim));

%% Split data

% Redefine delim
delim = 'newdata\r\n'; %not necessary to write CR and LF as char(ascii number)

% Params
S_params = strsplit(params_text, delim);

% File Size
F1_text = fileread(strcat(user_path,'fsize_c1.txt'));
F2_text = fileread(strcat(user_path,'fsize_c2.txt'));
F1_split = strsplit(F1_text, delim);
F2_split = strsplit(F1_text, delim);

% Cwnd stats
C1_text = fileread(strcat(user_path,'cwndstat_c1.txt'));
C2_text = fileread(strcat(user_path,'cwndstat_c2.txt'));
C1_split = strsplit(C1_text, delim);
C2_split = strsplit(C2_text, delim);

% Connections duration
D1_text = fileread(strcat(user_path,'begin_end_c1.txt'));
D2_text = fileread(strcat(user_path,'begin_end_c2.txt'));
D1_split = strsplit(D1_text, delim);
D2_split = strsplit(D2_text, delim);

% Loss data and total pkts
loss_text = fileread(strcat(user_path,'loss_data.txt'));
total_text = fileread(strcat(user_path,'total.txt'));
loss_split = strsplit(loss_text, delim);
total_split = strsplit(total_text, delim);

% Rtt estimation
ro1_text = fileread(strcat(user_path,'oprtt_c1.txt'));
ro2_text = fileread(strcat(user_path,'oprtt_c2.txt'));
ro1_split = strsplit(ro1_text, delim);
ro2_split = strsplit(ro2_text, delim);

% rc1_text = fileread(strcat(user_path,'est0.txt'));
% rc2_text = fileread(strcat(user_path,'est.txt'));
% rc1_split = strsplit(rc1_text, delim);
% rc2_split = strsplit(rc2_text, delim);

rc1_v2_text = fileread(strcat(user_path,'est0_v2.txt'));
rc2_v2_text = fileread(strcat(user_path,'est_v2.txt'));
rc1_v2_split = strsplit(rc1_v2_text, delim);
rc2_v2_split = strsplit(rc2_v2_text, delim);

% Queue statistics
qstats_text = fileread(strcat(user_path,'qstats.txt'));
qstats_split = strsplit(qstats_text, delim);

% Timeouts
to1_text = fileread(strcat(user_path,'timeouts_c1.txt'));
to2_text = fileread(strcat(user_path,'timeouts_c2.txt'));
to1_split = strsplit(to1_text, delim);
to2_split = strsplit(to2_text, delim);

% Loss pdf
lpdf_text = fileread(strcat(user_path,'loss_pdf.txt'));
lpdf_split = strsplit(lpdf_text, delim);

% Destroyed pkts
des1_text = fileread(strcat(user_path,'destroyed0.txt'));
des2_text = fileread(strcat(user_path,'destroyed.txt'));
des1_split = strsplit(des1_text, delim);
des2_split = strsplit(des2_text, delim);

% Bg end time
bgend_text = fileread(strcat(user_path,'bg_end.txt'));
bgend_split = strsplit(bgend_text, delim);

%% Loop over simulations

for i = 1:n_sim
    %% Params.txt     
   
    lines = strsplit(S_params{i+1}, '\r\n');
    for j = 1:length(lines)
        tline = lines{j};
        line_no = j;
        switch line_no
            case 1
                formatSpec = '%f';
                line_data = textscan(tline,formatSpec);
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
                formatSpec = '%f %f';
                line_data = textscan(tline,formatSpec);
                rtt1 = line_data{1};
                rtt2 = line_data{2};
            case 3
                bg_dist = tline;
            case 4
                formatSpec = '%f %f %f %f %f';
                line_data = textscan(tline,formatSpec);
                red_params = line_data; % smoothing, rec_red, min_th, max_p, gentle_flag               
            case 5
                formatSpec = '%f %f %f %f';
                line_data = textscan(tline,formatSpec);
                red_params2 = line_data;
            case 6                
                formatSpec = '%f';                
                line_data = textscan(tline,formatSpec);
                p_intr = line_data{1};
            otherwise
                %disp('no use for this line')
        end
    end
    
    %% Fsize 
    lines = strsplit(F1_split{i+1}, '\r\n');  % just 1 line in this case (2 but the last is empty and useless)
    tline = lines{1};
    formatSpec = '%f';
    line_data = textscan(tline,formatSpec);
    f_size = 8*line_data{1};
    
    %% Cwnd stats
    lines = C1_split{i+1}; 
    formatSpec = '%f %f';
    C_0 = textscan(lines,formatSpec,'Delimiter','\n');
    
    lines = C2_split{i+1};
    formatSpec = '%f %f';
    C = textscan(lines,formatSpec,'Delimiter','\n');
    
    %% Connections duration
    lines = D1_split{i+1}; 
    formatSpec = '%f';
    D_0 = textscan(lines,formatSpec,'Delimiter','\n');
    
    lines = D2_split{i+1};
    formatSpec = '%f';
    D = textscan(lines,formatSpec,'Delimiter','\n');
%     
%     dt_c1 = D_0{1}(end) - D_0{1}(end-1);
%     dt_c2 = D{1}(end) - D{1}(end-1);
    dt_c1 = C_0{2}(end) - 200;
    dt_c2 = C{2}(end) - 200;
    %% Throughput, goodput and eff throughput
    
    % Goodput per connection
    goodput_simulado_c1 = f_size/dt_c1; % should be in bytes without x8 factor
    goodput_simulado_c2 = f_size/dt_c2; % should be in bytes without x8 factor

    % Throughout per connection
    avg_cwnd_c1 = mean(C_0{1});
    avg_cwnd_c2 = mean(C{1});   
    th_sim_c1 = 8*avg_cwnd_c1/rtt1; % should be in bytes without x8 factor
    th_sim_c2 = 8*avg_cwnd_c2/rtt2; % should be in bytes without x8 factor
    
    % Effective throughput
    overhead_factor = (1500+8)/1460;
    eff_th_c1 = goodput_simulado_c1*overhead_factor;
    eff_th_c2 = goodput_simulado_c2*overhead_factor;    
    
    
    %% Loss data
    lines = loss_split{i+1}; 
    formatSpec = '%f';
    loss = textscan(lines,formatSpec,'Delimiter','\n');
    
    lines = total_split{i+1};
    formatSpec = '%f';
    total = textscan(lines,formatSpec,'Delimiter','\n');
    
    loss_c1 = loss{1}(1)+loss{1}(3)+loss{1}(5);
    loss_c2 = loss{1}(2)+loss{1}(4)+loss{1}(6);
    total_c1 = total{1}(1) - loss_c1;
    total_c2 = total{1}(2) - loss_c2;
  
    p1 = loss_c1/total_c1;
    p2 = loss_c2/total_c2;
    
    % Throughput 2
    th_pkt_c1 = total_c1*12000 / dt_c1;
    th_pkt_c2 = total_c2*12000 / dt_c2; 
    
    %% RTT estimation data
    lines = ro1_split{i+1}; 
    formatSpec = '%f %f';
    Ro1 = textscan(lines,formatSpec,'Delimiter','\n');
    
    lines = ro2_split{i+1};
    formatSpec = '%f %f';
    Ro2 = textscan(lines,formatSpec,'Delimiter','\n');
    
%     lines = rc1_split{i+1};     
%     formatSpec = '%f %f %f';
%     Rc1 = textscan(lines,formatSpec,'Delimiter','\n');
%     
%     lines = rc2_split{i+1};
%     formatSpec = '%f %f %f';
%     Rc2 = textscan(lines,formatSpec,'Delimiter','\n');
    
    lines = rc1_v2_split{i+1};     
    formatSpec = '%f %f';
    Rc1_v2 = textscan(lines,formatSpec,'Delimiter','\n');
    
    lines = rc2_v2_split{i+1};
    formatSpec = '%f %f';
    Rc2_v2 = textscan(lines,formatSpec,'Delimiter','\n');
    
    %% Qstats data
    lines = qstats_split{i+1}; 
    formatSpec = '%f %f %f %f %f';
    Q = textscan(lines,formatSpec,'Delimiter','\n');
    
    %% Timeouts data
    lines = to1_split{i+1}; 
    formatSpec = '%f %f';
    T_0 = textscan(lines,formatSpec,'Delimiter','\n');
    
    lines = to2_split{i+1};
    formatSpec = '%f %f';
    T = textscan(lines,formatSpec,'Delimiter','\n');
    
    %% Loss pdf data    
    lines = lpdf_split{i+1}; 
    formatSpec = '%f %f %f %f %f %f';
    P = textscan(lines,formatSpec,'Delimiter','\n');    
    
    %% Destroyed pkts data
    lines = des1_split{i+1}; 
    formatSpec = '%f %f %f';
    des1 = textscan(lines,formatSpec,'Delimiter','\n');
    
    lines = des2_split{i+1};
    formatSpec = '%f %f %f';
    des2 = textscan(lines,formatSpec,'Delimiter','\n');    
    
    %% BG end time
    lines = bgend_split{i+1}; 
    formatSpec = '%f';
    bg = textscan(lines,formatSpec,'Delimiter','\n');
    
    %% Fill cells
    rtt_cell = {{rtt1, rtt2}}; %
    alg_cell = {{alg_name}}; %
    bg_cell = {{bg_dist}}; %
    fsize_cell = {{f_size}}; %
    cwnd_cell = {{C, C_0}}; %
    dt_cell = {{dt_c1, dt_c2}}; %
    th_cell = {{th_sim_c1, th_sim_c2, th_pkt_c1, th_pkt_c2}}; %
    gp_cell = {{goodput_simulado_c1, goodput_simulado_c2}}; %
    th_eff_cell = {{eff_th_c1, eff_th_c2}}; %
    loss_cell = {{p1, p2, p_intr}}; %
    est_cell = {{Ro1, Ro2, Rc1_v2, Rc2_v2}}; %
    q_cell = {{Q}}; %
    to_cell = {{T, T_0}}; %
    redp_cell = {{red_params, red_params2}}; %
    lpdf_cell = {{P}};   
    destroyed_cell = {{des1, des2}};
    bgend_cell = {{bg}};
    %% Save structure 
    
    results_struct = struct(f1, alg_cell, f2, rtt_cell, f3, bg_cell, f4, fsize_cell, f5, cwnd_cell, f6, dt_cell, f7, th_cell, f8, gp_cell, f9, loss_cell, f10, q_cell, f11, est_cell, f12, th_eff_cell, f13, to_cell, f14, redp_cell, f15, lpdf_cell, f16, destroyed_cell, f17, bgend_cell);
%   date_time = datetime('now');
%   DateString = datestr(date_time);
%   newStr = strrep(DateString,' ','_');
%   newStr = strrep(newStr,':','-');
    algStr = num2str(alg_no);
    results_path = strcat('./resultados/', dirStr,'/');
    full_path = [results_path dirStr ' ' algStr ' ' num2str(i) '.mat'];
    %full_path = strcat(results_path, newStr, blanks(1), algStr, blanks(1),num2str(i), '.mat');
    save(full_path, 'results_struct')
    
end


%% Get simulation parameters from opnet written files
% 
% overhead_factor = (1500+8)/1460;
% 
% % Read parameters file
% fileID = fopen('C:\\D\\Sefe\\Universidad\\opnet\\opnet_res\\params.txt');
% cur_line = fgetl(fileID);
% line_no = 1;
% while ischar(cur_line)
%     % Process current line
%     switch line_no
%         case 1
%             % Algorithm name
%             formatSpec = '%f';
%             line_data = textscan(cur_line,formatSpec);
%             alg_no = line_data{1};
%             switch alg_no
%                 case 1
%                     alg_name = 'DropTail';
%                 case 2
%                     alg_name = 'RED';
%                 case 3
%                     alg_name = 'TTF';
%                 otherwise
%                     disp('wrong alg_no')
%             end
%         case 2
%             % RTT per connection
%             formatSpec = '%f %f';
%             line_data = textscan(cur_line,formatSpec);
%             rtt1 = line_data{1};
%             rtt2 = line_data{2};
%         case 3
%             % traffic distribution
%             bg_dist = cur_line;
%         case 4
%             % Intrinsic loss
%             formatSpec = '%f';
%             line_data = textscan(cur_line,formatSpec);
%             p_intr = line_data{1};
%         otherwise
%             disp('no use for this line')
%     end
%      
%     % Read next line
%     cur_line = fgetl(fileID);
%     line_no = line_no + 1;
% end
% fclose(fileID);
% 
% % FTP file size (bits)
% fileID = fopen('C:\fsize_c1.txt');
% formatSpec = '%f'; %  instancia, cwnd, time
% P = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% f_size = 8 * P{1};
% %f_size = 8*200*10^6;
% 
% %% Read files
% 
% fileID = fopen('C:\begin_end_c2.txt');
% formatSpec = '%f'; %  instancia, cwnd, time
% P = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\begin_end_c1.txt');
% formatSpec = '%f'; %  instancia, cwnd, time
% P_0 = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\loss_data.txt');
% formatSpec = '%f'; %  instancia, cwnd, time
% loss = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\total.txt');
% formatSpec = '%f'; %  instancia, cwnd, time
% total = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\cwndstat_c2.txt');
% formatSpec = '%f %f'; %  cwnd, time
% C = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\cwndstat_c1.txt');
% formatSpec = '%f %f'; %  cwnd, time
% C_0 = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\qstats.txt');
% formatSpec = '%f %f %f %f'; %  cwnd, time
% Q = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\oprtt_c1.txt');
% formatSpec = '%f %f'; %  cwnd, time
% Ro1 = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\oprtt_c2.txt');
% formatSpec = '%f %f'; %  cwnd, time
% Ro2 = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\est0.txt');
% formatSpec = '%f %f %f'; %  cwnd, time
% Rc1 = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% fileID = fopen('C:\est.txt');
% formatSpec = '%f %f %f'; %  cwnd, time
% Rc2 = textscan(fileID,formatSpec,'Delimiter','\n');
% fclose(fileID);
% 
% 
% 
% %% Get stats from data
% 
% % length = length(P{1});
% % fprintf('Array length = %d\n', length)
% 
% % Connection duration
% dt_c1 = P_0{1}(end) - P_0{1}(end-1)
% dt_c2 = P{1}(end) - P{1}(end-1)
% 
% % Loss per connection
% loss_c1 = loss{1}(1)+loss{1}(3)+loss{1}(5)
% loss_c2 = loss{1}(2)+loss{1}(4)+loss{1}(6)
% total_c1 = total{1}(1)
% total_c2 = total{1}(2)
% p1 = loss_c1/total_c1
% p2 = loss_c2/total_c2
% 
% % Goodput per connection
% goodput_simulado_c1 = f_size/dt_c1
% goodput_simulado_c2 = f_size/dt_c2
% 
% % Throughout per connection
% avg_cwnd_c1 = mean(C_0{1});
% avg_cwnd_c2 = mean(C{1});
% %plot(C{2}, C{1})  
% th_sim_c1 = avg_cwnd_c1/rtt1;
% th_sim_c2 = avg_cwnd_c2/rtt2;
% fprintf('Avg cwnd c1 = %d, Avg throughput = %f\n', avg_cwnd_c1, th_sim_c1)
% fprintf('Avg cwnd c2 = %d, Avg throughput = %f\n', avg_cwnd_c2, th_sim_c2)
% 
% % Theoretical throughout per connection
% throughput_teo_c1 = 8*1500*(sqrt(3/(2*p1)))/rtt1
% throughput_teo_c2 = 8*1500*(sqrt(3/(2*p2)))/rtt2
% 
% % Error between simulated throughput and theoretical throughput in percentage
% error_c1 = abs(1- th_sim_c1/throughput_teo_c1)*100
% error_c2 = abs(1- th_sim_c2/throughput_teo_c2)*100
% 
% 
% % Error in the loss rate (simulation vs algorithm formula)
% rate_error = abs(1-sqrt((loss_c1/loss_c2))/(rtt2/rtt1))*100
% 
% % Fairness plot stuff
% x_array = [0 1];
% x_array_2 = [0 1];
% y_array_eff = [1 0];
% y_array_fair = [0 1];
% 
% % Maximum theoretical throughputs
% %p_intr = 0.001
% max_th_c1 = 8*1500*(sqrt(3/(2*p_intr)))/rtt1
% max_th_c2 = 8*1500*(sqrt(3/(2*p_intr)))/rtt2
% rel_th_c1 = th_sim_c1/max_th_c1;
% rel_th_c2 = th_sim_c2/max_th_c1;
% 
% %figure()
% %plot(x_array, y_array_eff, '--')
% %hold on
% %plot(x_array_2, y_array_fair, '--r')
% %plot(rel_th_c2, rel_th_c1, 'ko') % con normalizacion
% plot(th_sim_c2, th_sim_c1, 'ko') % sin normalizacion
% 
% 
% %% Save results in .mat file
% 
% f1 = 'alg';
% f2 = 'rtts';
% f3 = 'bg_dist';
% f4 = 'file_size';
% f5 = 'cwnd';
% f6 = 'conn_dur';
% f7 = 'throughput';
% f8 = 'goodput';
% f9 = 'loss';
% f10 = 'qstats';
% f11 = 'rtt_est';
% f12 = 'th_eff';
% 
% rtt_cell = {{rtt1, rtt2}};
% alg_cell = {{alg_name}};
% bg_cell = {{bg_dist}};
% fsize_cell = {{f_size}};
% cwnd_cell = {{C, C_0}};
% dt_cell = {{dt_c1, dt_c2}};
% th_cell = {{th_sim_c1, th_sim_c2}};
% gp_cell = {{goodput_simulado_c1, goodput_simulado_c2}};
% th_eff_cell = {{goodput_simulado_c1*overhead_factor, goodput_simulado_c2*overhead_factor}};
% loss_cell = {{p1, p2, p_intr}};
% est_cell = {Ro1{1}, Ro1{2}, Ro2{1}, Ro2{2}, Rc1{1}, Rc1{2}, Rc2{1}, Rc2{2}};
% q_cell = {{Q{1}, Q{2}, Q{3}, Q{4}}};
% results = struct(f1, alg_cell, f2, rtt_cell, f3, bg_cell, f4, fsize_cell, f5, cwnd_cell, f6, dt_cell, f7, th_cell, f8, gp_cell, f9, loss_cell, f10, q_cell, f11, est_cell, f12, th_eff_cell);
% %date_str = date;
% date_time = datetime('now');
% DateString = datestr(date_time);
% newStr = strrep(newStr,' ','_');
% newStr = strrep(newStr,':','-');
% algStr = num2str(alg_no);
% str_2 = strcat(newStr, algStr, '.mat');
% save(str_2, 'results')
% 
% toc



