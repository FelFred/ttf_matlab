%% Info

% v1: utilization is approximated. 
% v2: utilization is no longer an approximation. Partial pkts in window are
% considered now.


%% Clean stuff
clear all
close all
clc

tic
%% Initialization

file_path = 'C:\\D\\Sefe\\Universidad\\opnet\\link_output 25-175 91 v2.txt';
fig_number = 1;

init_time = 0;
end_time = 600;
link_rate = 1e8;
bg_pkt_size = 11744;
c_pkt_size = 12064;
window_size = 0.2;
full_util = link_rate*window_size;
dt = window_size * 2;
time_array = init_time:dt:end_time;
percentage = zeros(length(time_array),1);
util_array = zeros(3, length(time_array));

file_size = 80000000;
fsize_conv_factor = 10^6;
c_init_time = file_size / fsize_conv_factor;
c_init_delayed = c_init_time + 5; 
c1_end = 0;
c2_end = 0;

addpath('./funciones/');

%% Read data
output_data = fileread(file_path);
formatSpec = '%f %f %f';
line_data = textscan(output_data,formatSpec);
data1 = line_data{1};
data2 = line_data{2};
data3 = line_data{3};
data_array = horzcat(data1,data2,data3);


%% Get info from data
for i = 1:length(time_array)
    t_now = time_array(i);
    ti = t_now - window_size/2;
    tf = t_now + window_size/2;
    c1_counter = 0;
    c2_counter = 0;
    bg_counter = 0;
    partial_left = 0;
    partial_right = 0;
    partial_c1 = 0;
    partial_c2 = 0;
    partial_bg = 0;
    
    
    % Get amount of data in current window
    for j = 1:length(data_array(:,1))        
        t_j = data_array(j,2);
        out = data_array(j,1);
        pkt_dt = data_array(j,3)/link_rate;
       
        % Check for fully contained pkts (in window)
        if ( (t_j+pkt_dt<tf) && (t_j >=ti) )
            if (out == 0)
                c1_counter = c1_counter + 1;
            elseif (out == 2)
                c2_counter = c2_counter + 1;
            elseif (out == 4)
                bg_counter = bg_counter + 1;
            end            
        end
        
        % Check for partially contained pkts
        if ( (t_j < ti) && (t_j+pkt_dt > ti))                                         % left edge of window 
            partial_left = data_array(j,3)*(t_j+pkt_dt - ti);                         % multiply pkt_size * (pkt portion which fits inside of the window)
             if (out == 0)
                partiial_c1 = partial_c1 + partial_left;
            elseif (out == 2)
                partiial_c2 = partial_c2 + partial_left;
            elseif (out == 4)
                partiial_bg = partial_bg + partial_left;
            end  
        end       
        
        if ( (t_j < tf) && (t_j+pkt_dt > tf))                                         % right edge of window 
            partial_right = data_array(j,3)*(tf - t_j);                                % multiply pkt_size * (pkt portion which fits inside of the window) 
             if (out == 0)
                partiial_c1 = partial_c1 + partial_right;
            elseif (out == 2)
                partiial_c2 = partial_c2 + partial_right;
            elseif (out == 4)
                partiial_bg = partial_bg + partial_right;
            end  
        end 
        
    end
    
    % Estimación hecha por código anterior es lo suficientemente exacta si se compara con datos del gráfico 2 al menos.
    % Datos de begin_end_c1 y begin_end_c2: 185.455041099329 , 291.089324782613
    % Datos de simulación 91
    if (c1_counter == 0 && c1_end == 0 && ti > c_init_time)
        c1_end= ti;
        disp(['c1 end at time ' num2str(ti)])
    end
    if (c2_counter == 0 && c2_end == 0 && ti > c_init_time)
        c2_end = ti;        
        disp(['c2 end at time ' num2str(ti)])
    end
    
    % Get total data in current windoww
    window_data = bg_counter * bg_pkt_size + (c1_counter+c2_counter) * c_pkt_size + partial_left + partial_right;    
    
    % Calculate utilization dividing by full utilization
    percentage(i) = 100 * window_data / full_util;
    c1_util = 100 * (c1_counter * c_pkt_size + partial_c1) / full_util;
    c2_util = 100 * (c2_counter * c_pkt_size + partial_c2) / full_util;
    bg_util = 100 * (bg_counter * bg_pkt_size + partial_bg) / full_util;
    util_array(:,i) = [bg_util; c1_util ; c2_util ;];
    
end

%% Get avg utilizacion in the interval where both connections are active

% Get chopped array of total utilization measured in percentage 
total_util_chopped = chop_interval(percentage, time_array, c1_end-10-c_init_time, c2_end-10-c_init_time, c_init_delayed);
avg_util = mean(total_util_chopped{1});
disp (['Avg utilization while competing = ' num2str(avg_util) '%'])

%% Plot results
figure(fig_number)
fig_number = fig_number + 1;
bar(time_array, percentage')
title('Link utilization vs time')
xlabel('Time [s]')
ylabel('Utilization [%]')
ylim([0 110])
% print -depsc MySavedPlot
% print -dpng MySavedPlot


figure(fig_number)
fig_number = fig_number + 1;
bar(time_array, util_array', 'stacked')
title('Link utilization vs time')
xlabel('Time [s]')
ylabel('Utilization [%]')
ylim([0 110])
legend('bg', 'c1', 'c2')
print -dpng MySavedPlot

figure(fig_number)
fig_number = fig_number + 1;
bar(time_array, util_array')
title('Link utilization vs time')
xlabel('Time [s]')
ylabel('Utilization [%]')
ylim([0 110])
legend('bg', 'c1', 'c2')

toc

