% This code was developed to process the data of a set of X simulations,
% where X is the number of bg traffic distributions used.
% The whole set of data comes from 1 seed

clear all
close all
clc

%% Parameters

% Choose dataset manually
datasetStr = '30-Nov-2018_22-34-17';
results_path = ['./resultados/' datasetStr '/'];

% Change directory to dataset path
cd(results_path)

% Get filename base string (same as the dataset folder)
baseStr = ['./' datasetStr]; % .mat filenames initiate with the same string as the folder's name

% Get number of simulations of the dataset using dir command
datasetFiles = dir('.');
n_sim = size(datasetFiles,1) - 2; % 2 "files" would be "." and ".." in dir's output

% Other parameters
%num_alg = 1; % DropTail, RED and TTF
%num_rtt = 2; % 0.15 and 0.2 for connection 2
%num_bg = 2;  % constant with values: 0.00002 and 0.00001168
%n_seeds = 9;
 

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

th_array = zeros(3,2,n_sim); % 3 metrics: gp,th,eff_th + 2 connections + 9 simulations, each with a different bg distribution
q_cell = cell(n_sim,1);
alg_idx = 1;

q_array = zeros(n_sim,1);
qstd_array = zeros(n_sim,1);
bg_array = zeros(n_sim,1);

for j=1:n_sim         
   th_array(1, :, alg_idx) = [results_cell{j}.throughput{1} results_cell{j}.throughput{2}];
   th_array(2, :, alg_idx) = [results_cell{j}.goodput{1} results_cell{j}.goodput{2}];
   th_array(3, :, alg_idx) = [results_cell{j}.th_eff{1} results_cell{j}.th_eff{2}];
   q_cell{alg_idx} = results_cell{j}.qstats{1}{2}; % 2 is cur_qsize = instantaneous or smoothed queue size according to smoothing flag value
   alg_idx = alg_idx + 1;   
   
   % Get q data in different arrays for errorbar   (both from instantaneous measurements) 
   q_array(j) = mean(results_cell{j}.qstats{1}{1});
   qstd_array(j) = std(results_cell{j}.qstats{1}{1});
   
   % Get bg dist array
   bg_char = char(results_cell{j}.bg_dist);
   bg_cut = bg_char(11:end-1);
   formatSpec = '%f';
   pkt_iat_cell = textscan(bg_cut, formatSpec);
   pkt_iat = pkt_iat_cell{1};
   bg_array(j) = pkt_iat;
end

%% Get avg and std for throughput, goodput and effective_throughput
% Transform Inf to NaNs (Inf = connection failed)
th_array(th_array == Inf) = nan;

% Get matrix average over bg traffic dimension (ignoring NaNs)
th = mean(th_array, 3, 'omitnan');   
    
%% Get avg and std for (avg) queue size and queueing delay(the previous "amplified" by a factor)
alg_q_array = zeros(n_sim,2);

for k = 1:n_sim
    alg_q_array(k,:) = [mean(q_cell{k}) std(q_cell{k})];
end

alg_qs = mean(alg_q_array,1);

%% Get timeout data arrays
c1_timeouts = zeros(n_sim,1);
c2_timeouts = zeros(n_sim,1);
for l = 1:n_sim
    c1_timeouts(l) = length(results_cell{l}.timeouts{1}{1}) - 1;    
    c2_timeouts(l) = length(results_cell{l}.timeouts{2}{1}) - 1;
end

%% Plot data

% Plot "th1" vs "th2" (with "th" = th, gp or eff_th)
gp_array = squeeze(th_array(3,:,:))';
figure()
bar(bg_array, gp_array)
title('Goodput(c1,c2) for different pkt iat')
xlabel('Simulation')
ylabel('Goodput[bits]')

figure()
hold on
x_plot = squeeze(th_array(3,2,:));
y_plot = squeeze(th_array(3,1,:));
plot(x_plot, y_plot, 'r-o', 'MarkerSize', 10)
xlim([10^5 10^7])
ylim([10^5 10^7])
title('Goodput per connection (fairness)')
plot([10^5 10^7], [10^5 10^7], 'm--')
legend('Algorithm')
hold off

% Plot cwnd (must be tested to achieve a meaningful figure)
sim_number = 6;
c1_cwnd = results_cell{sim_number}.cwnd{1};
c2_cwnd = results_cell{sim_number}.cwnd{2};
figure()
subplot(2,1,1)
plot(c1_cwnd{2}, c1_cwnd{1})
subplot(2,1,2)
plot(c2_cwnd{2}, c2_cwnd{1})

% Plot timeouts per connection vs simulation
sim_array = 1:n_sim;
timeouts_array = horzcat(c1_timeouts, c2_timeouts);
figure()
bar(sim_array, timeouts_array)
title('Timeouts per connection vs simulation number')
xlabel('Simulation Number')
ylabel('Timeouts')

%% Plot avg queue size vs bg traffic (RED_TTF)

% figure()
% plot(bg_array, q_array)
% title('Average queue vs pkt_iat');

figure()
errorbar(bg_array, q_array, qstd_array)
title('Average queue vs pkt_iat');

figure()
subplot(2,1,1)
plot(results_cell{9}.qstats{1}{4}, results_cell{9}.qstats{1}{1})
subplot(2,1,2)
plot(results_cell{9}.qstats{1}{4}, results_cell{9}.qstats{1}{2})

figure()
subplot(2,1,1)
plot(results_cell{1}.qstats{1}{4}, results_cell{1}.qstats{1}{1})
subplot(2,1,2)
plot(results_cell{1}.qstats{1}{4}, results_cell{1}.qstats{1}{2})

%% Plot loss pdf 

sim_number = 9;
pdf_data = [results_cell{9}.loss_pdf{1}{1} results_cell{9}.loss_pdf{1}{2}]
[~,idx] = sort(pdf_data(:,1)); % sort just the first column
sorted_pdf = pdf_data(idx,:);   % sort the whole matrix using the sort indices

figure()
plot(sorted_pdf(:,1), sorted_pdf(:,2))
title('Loss pdf')
xlabel('Avg queue size')
ylabel('Loss probability')

%% Return to previous folder

cd ..
cd ..
