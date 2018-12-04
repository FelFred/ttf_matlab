%% Code description
%{
This code was developed to process the data of a set of 12 simulations (3 algorithms, and X seeds)

Inputs:
- 1 specific scenario
- 3 algorithms (DT, RED , TTF)
- N seeds

Outputs:
- Fig 1:        Goodput(c1,c2) for DT, RED, TTF
- Fig 2:        Fairness graph for 3 algorithms (using goodput)
- Fig 3:        Errorbar plot for 3 algorithms, using avg and std of avg queue size
- Fig 4:        Cwnd for both connections of sim number of specific simulation
- Fig 5:        Timeouts for both connections per simulation
- Commented:    Some plots that are in bg_analysis, should be deleted
%}


%% Clean stuff

clear all
close all
clc

%% Parameters

% Choose dataset manually
datasetStr = '04-Dec-2018_16-00-55';
results_path = ['./resultados/' datasetStr '/'];

% Change directory to dataset path
cd(results_path)

% Get filename base string (same as the dataset folder)
baseStr = ['./' datasetStr]; % .mat filenames initiate with the same string as the folder's name

% Get number of simulations of the dataset using dir command
datasetFiles = dir('.');
n_sim = size(datasetFiles,1) - 2; % 2 "files" would be "." and ".." in dir's output

% Other parameters
num_alg = 3; % DropTail, RED and TTF
%num_rtt = 2; % 0.15 and 0.2 for connection 2
%num_bg = 2;  % constant with values: 0.00002 and 0.00001168
n_seeds = 5;
 

%% Iterate over simulations and read structures
results_cell = cell(n_sim,1);
for i = 1:n_sim
   % Get name from structure
   fileName = datasetFiles(i+2).name;
   
   % Prepare variable name
   results_struct = struct([]); % creates empty structure
   results_str = 'results_struct';
      
   % Load structure into variable
   load(fileName, results_str);
   
   % Store in cell
   results_cell{i} = results_struct;
end

%% Identify algorithms data 
droptail_cell = cell(n_seeds,1);
red_cell = cell(n_seeds,1);
ttf_cell = cell(n_seeds,1);
droptail_idx = 1;
red_idx = 1;
ttf_idx = 1;

% Matrix to store th, gp and eff_th
droptail_th_array = zeros(3, 2, n_seeds);
red_th_array = zeros(3, 2, n_seeds);
ttf_th_array = zeros(3, 2, n_seeds);

% Cells with queue size and RTT estimations
dt_q_cell = cell(n_seeds,1);
red_q_cell = cell(n_seeds,1);
ttf_q_cell = cell(n_seeds,1);

for j=1:n_sim
   alg = results_cell{j}.alg{1};    
    
   if (strcmp(alg,'DropTail'))
       droptail_cell{droptail_idx} = results_cell{j} ;      
       droptail_th_array(1, :, droptail_idx) = [results_cell{j}.throughput{1} results_cell{j}.throughput{2}];
       droptail_th_array(2, :, droptail_idx) = [results_cell{j}.goodput{1} results_cell{j}.goodput{2}];
       droptail_th_array(3, :, droptail_idx) = [results_cell{j}.th_eff{1} results_cell{j}.th_eff{2}];
       dt_q_cell{droptail_idx} = results_cell{j}.qstats{1}{2}; % 2 is cur_qsize = instantaneous or smoothed queue size according to smoothing flag value
       droptail_idx = droptail_idx + 1;
   elseif (strcmp(alg,'RED'))
       red_cell{red_idx} = results_cell{j};
       red_th_array(1, :, red_idx) = [results_cell{j}.throughput{1} results_cell{j}.throughput{2}];
       red_th_array(2, :, red_idx) = [results_cell{j}.goodput{1} results_cell{j}.goodput{2}];
       red_th_array(3, :, red_idx) = [results_cell{j}.th_eff{1} results_cell{j}.th_eff{2}]; 
       red_q_cell{red_idx} = results_cell{j}.qstats{1}{2};
       red_idx = red_idx + 1;
   elseif (strcmp(alg,'TTF'))
       ttf_cell{ttf_idx} = results_cell{j};
       ttf_th_array(1, :, ttf_idx) = [results_cell{j}.throughput{1} results_cell{j}.throughput{2}];
       ttf_th_array(2, :, ttf_idx) = [results_cell{j}.goodput{1} results_cell{j}.goodput{2}];
       ttf_th_array(3, :, ttf_idx) = [results_cell{j}.th_eff{1} results_cell{j}.th_eff{2}]; 
       ttf_q_cell{ttf_idx} = results_cell{j}.qstats{1}{2};
       ttf_idx = ttf_idx + 1;       
   end
   
end

%% Get avg and std for throughput, goodput and effective_throughput
% Transform Inf to NaNs (Inf = connection failed)
droptail_th_array(droptail_th_array == Inf) = nan;
red_th_array(red_th_array == Inf) = nan;
ttf_th_array(ttf_th_array == Inf) = nan;

% Get matrix average over seed dimension (ignoring NaNs)
dt_th = mean(droptail_th_array, 3, 'omitnan');
red_th = mean(red_th_array, 3, 'omitnan');
ttf_th = mean(ttf_th_array, 3, 'omitnan');    
    
%% Get avg and std for (avg) queue size and queueing delay(the previous "amplified" by a factor)
dt_q_array = zeros(n_seeds,2);
red_q_array = zeros(n_seeds,2);
ttf_q_array = zeros(n_seeds,2);

for k = 1:n_seeds
    dt_q_array(k,:) = [mean(dt_q_cell{k}) std(dt_q_cell{k})];    
    red_q_array(k,:) = [mean(red_q_cell{k}) std(red_q_cell{k})];    
    ttf_q_array(k,:) = [mean(ttf_q_cell{k}) std(ttf_q_cell{k})];
end

dt_qs = mean(dt_q_array,1);
red_qs = mean(red_q_array,1);
ttf_qs = mean(ttf_q_array,1);

%% Get avg and std for RTT (opnet and ttf estimation)

%% Get timeout data arrays
c1_timeouts = zeros(n_seeds,1);
c2_timeouts = zeros(n_seeds,1);
for l = 1:n_sim
    c1_timeouts(l) = length(results_cell{l}.timeouts{1}{1}) - 1;    
    c2_timeouts(l) = length(results_cell{l}.timeouts{2}{1}) - 1;
end

%% Plot data

% Plot "th1" vs "th2" (with "th" = th, gp or eff_th)
gp_array = [dt_th(3,:); red_th(3,:); ttf_th(3,:)];
algorithms = categorical({'DropTail','RED','TTF'});
figure(1)
title('Goodput(c1,c2) for DT, RED, TTF')
bar(algorithms, gp_array)
xlabel('Algorithm')
ylabel('Goodput[bits]')

figure(2)
plot(dt_th(3,2), dt_th(3,1), 'ro', 'MarkerSize', 10)
xlim([10^5 2*10^7])
ylim([10^5 2*10^7])
hold on
plot(red_th(3,2), red_th(3,1), 'ko', 'MarkerSize', 10)
title('Goodput per connection')
plot(ttf_th(3,2), ttf_th(3,1), 'bo', 'MarkerSize', 10)
plot([10^5 2*10^7], [10^5 2*10^7], 'm--')
legend('Droptail','RED', 'TTF')
hold off

% Plot queueing_delay / (avg) queue size for every algorithm
figure(3)
errorbar(1,dt_qs(1), dt_qs(2), 'rx')
title('Queue size average and std through simulation')
ylim([0 100])
hold on
errorbar(2,red_qs(1), red_qs(2), 'kx')
hold on
errorbar(3,ttf_qs(1), ttf_qs(2), 'bx')
legend('Droptail','RED', 'TTF')
hold off

% Plot RTT for every algorithm 
% figure()
% errorbar()

% Plot cwnd (must be tested to achieve a meaningful figure)
sim_number = 11;
c1_cwnd = results_cell{sim_number}.cwnd{1};
c2_cwnd = results_cell{sim_number}.cwnd{2};
figure(4)
subplot(2,1,1)
plot(c1_cwnd{2}, c1_cwnd{1})
title(['Cwnd for both connections of sim number ' num2char(sim_num)])
subplot(2,1,2)
plot(c2_cwnd{2}, c2_cwnd{1})

% Plot timeouts per connection vs simulation
sim_array = 1:15;
timeouts_array = horzcat(c1_timeouts, c2_timeouts);
figure(5)
bar(sim_array, timeouts_array)
title('Timeouts per connection vs simulation number')
xlabel('Simulation Number')
ylabel('Timeouts')

%% Plot avg queue size vs bg traffic (RED_TTF)

% q_array = zeros(n_sim,1);
% qstd_array = zeros(n_sim,1);
% bg_array = zeros(n_sim,1);
% 
% for l = 1:n_sim
%     q_array(l) = mean(results_cell{l}.qstats{1}{1});
%     qstd_array(l) = std(results_cell{l}.qstats{1}{1});
%     bg_char = char(results_cell{l}.bg_dist);
%     bg_cut = bg_char(11:end-1);
%     formatSpec = '%f';
%     pkt_iat_cell = textscan(bg_cut, formatSpec);
%     pkt_iat = pkt_iat_cell{1};
%     bg_array(l) = pkt_iat;
% end
% 
% figure()
% plot(bg_array, q_array)
% title('Average queue vs pkt_iat');
% 
% figure()
% errorbar(bg_array, q_array, qstd_array)
% title('Average queue vs pkt_iat');

% figure()
% subplot(2,1,1)
% plot(results_cell{7}.qstats{1}{4}, results_cell{7}.qstats{1}{1})
% subplot(2,1,2)
% plot(results_cell{7}.qstats{1}{4}, results_cell{7}.qstats{1}{2})
% 
% figure()
% subplot(2,1,1)
% plot(results_cell{11}.qstats{1}{4}, results_cell{11}.qstats{1}{1})
% subplot(2,1,2)
% plot(results_cell{11}.qstats{1}{4}, results_cell{11}.qstats{1}{2})
%% Return to previous folder

cd ..
cd ..
