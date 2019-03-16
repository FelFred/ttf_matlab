%% Initialization

file_path = 'C:\\D\\Sefe\\Universidad\\opnet\\link_output.txt';
fig_number = 1;

init_time = 0;
end_time = 600;
link_rate = 1e8;
window_size = 10;
full_util = link_rate*window_size;
dt = 1;
time_array = init_time:dt:end_time;
percentage = zeros(length(time_array),1);

%% Read data
output_data = fileread(file_path);
formatSpec = '%f %f %f';
line_data = textscan(output_data,formatSpec);

%% Get info from data
for i = 1:length(time_array)    
    % Get amount of data in current window
    
    
    
    % Calculate utilization dividing by full utilization
%     percentage(i) = window_data / full_util;
end

%% Plot results
% figure(fig_number)
% fig_number = fig_number + 1;
% bar(time_array, percentage')
% title('Link utilization vs time')
% xlabel('Time [s]')
% ylabel('Utilization [%]')



