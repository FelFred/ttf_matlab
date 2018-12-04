%% Code description
%{
 This code was developed to process the data of a set of X simulations, where X is the number of bg traffic distributions used.
 The whole set of data comes from 1 seed.

Inputs:
- 1 specific scenario
- X pkt iat(interarrival time) values (lower values equal more pkts per second)    

Outputs:
- Fig 1:        Goodput (c1,c2) vs pkt_iat
- Fig 2:        Fairness graph (trajectory given by different pkt_iat values)
- Fig 3:        Cwnd vs time of both connections for a particular simulation (fixed pkt_iat)
- Fig 4:        Timeouts per connection vs pkt_iat
- Fig 5:        Average queue size errorbar plot vs pkt_iat
- Figs 6-7:     Instantaneous queue size vs smoothed queue size (avg'd) for 2 particular simulations 
- Fig 8:        Loss pdf for the same simulation used for fig 3
- Figs 9-10:    Opnet vs ttf rtt estimations for both c1 and c2 respectively.
                This data is also from the specific simulation used for figs 3 and 8
- Figs 11-12:   Time distance between samples for c2. Opnet vs ttf
- Figs 13-14:   Ttf rtt estimation for c1. Counter info below

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
figure(1)
bar(bg_array, gp_array)
title('Goodput(c1,c2) for different pkt iat')
xlabel('Simulation')
ylabel('Goodput[bits]')

figure(2)
hold on
x_plot = squeeze(th_array(3,2,:));
y_plot = squeeze(th_array(3,1,:));
plot(x_plot, y_plot, 'r-o', 'MarkerSize', 10)
xlim([10^5 2*10^7])
ylim([10^5 2*10^7])
title('Goodput per connection (fairness)')
plot([10^5 2*10^7], [10^5 2*10^7], 'm--')
legend('TTF')
hold off

% Plot cwnd (must be tested to achieve a meaningful figure)
sim_number = 1;
c1_cwnd = results_cell{sim_number}.cwnd{1};
c2_cwnd = results_cell{sim_number}.cwnd{2};
figure(3)
subplot(2,1,1)
plot(c1_cwnd{2}, c1_cwnd{1})
title(['cwnd of sim ' num2str(sim_number) ', pkt iat = ' num2str(bg_array(sim_number))])
subplot(2,1,2)
plot(c2_cwnd{2}, c2_cwnd{1})

% Plot timeouts per connection vs simulation
sim_array = 1:n_sim;
timeouts_array = horzcat(c1_timeouts, c2_timeouts);
figure(4)
bar(sim_array, timeouts_array)
title('Timeouts per connection vs simulation number')
xlabel('Simulation Number')
ylabel('Timeouts')

%% Plot avg queue size vs bg traffic (RED_TTF)

figure(5)
errorbar(bg_array, q_array, qstd_array)
title('Average queue vs pkt_iat');

figure(6)
subplot(2,1,1)
plot(results_cell{9}.qstats{1}{4}, results_cell{9}.qstats{1}{1})
subplot(2,1,2)
plot(results_cell{9}.qstats{1}{4}, results_cell{9}.qstats{1}{2})

figure(7)
subplot(2,1,1)
plot(results_cell{1}.qstats{1}{4}, results_cell{1}.qstats{1}{1})
subplot(2,1,2)
plot(results_cell{1}.qstats{1}{4}, results_cell{1}.qstats{1}{2})

%% Plot loss pdf 

%sim_number = 1;
pdf_data = [results_cell{sim_number}.loss_pdf{1}{1} results_cell{sim_number}.loss_pdf{1}{2}]
[~,idx] = sort(pdf_data(:,1)); % sort just the first column
sorted_pdf = pdf_data(idx,:);   % sort the whole matrix using the sort indices

figure(8)
plot(sorted_pdf(:,1), sorted_pdf(:,2), 'x')
title('Loss pdf')
xlabel('Avg queue size')
ylabel('Loss probability')

%% Plot rtt estimations from tcp and ttf

%sim_number = 1;

oprtt_c1_time = results_cell{sim_number}.rtt_est{1}{2};
oprtt_c1_data = results_cell{sim_number}.rtt_est{1}{1};
oprtt_c2_time = results_cell{sim_number}.rtt_est{2}{2};
oprtt_c2_data = results_cell{sim_number}.rtt_est{2}{1};

ttf_c1_time = results_cell{sim_number}.rtt_est{3}{2};
ttf_c1_data = results_cell{sim_number}.rtt_est{3}{1};
ttf_c2_time = results_cell{sim_number}.rtt_est{4}{2};
ttf_c2_data = results_cell{sim_number}.rtt_est{4}{1};

figure(9)
subplot(2,1,1)
plot(oprtt_c1_time, oprtt_c1_data)
title('Opnet vs ttf rtt estimations for c1')
subplot(2,1,2)
plot(ttf_c1_time, ttf_c1_data)

figure(10)
subplot(2,1,1)
plot(oprtt_c2_time, oprtt_c2_data)
title('Opnet vs ttf rtt estimations for c2')
subplot(2,1,2)
plot(ttf_c2_time, ttf_c2_data)

%% Plot distance (in time units) between rtt samples

oprtt_c1_len = length(oprtt_c1_time);
oprtt_c2_len = length(oprtt_c2_time);

ttf_c1_len = length(ttf_c1_time);
ttf_c2_len = length(ttf_c2_time);

oprtt_c1_diff = zeros(oprtt_c1_len-1,1);
oprtt_c2_diff = zeros(oprtt_c2_len-1,1);
ttf_c1_diff = zeros(ttf_c1_len-1,1);
ttf_c2_diff = zeros(ttf_c2_len-1,1);

% oprtt_c1_diff(1) = oprtt_c1_time(1);
% oprtt_c2_diff(1) = oprtt_c2_time(1);
% ttf_c1_diff(1) = oprtt_c1_time(1);
% ttf_c2_diff(1) = oprtt_c1_time(1);

for i = 2:oprtt_c1_len
    oprtt_c1_diff(i-1) = oprtt_c1_time(i)-oprtt_c1_time(i-1);    
end

for i = 2:oprtt_c2_len
    oprtt_c2_diff(i-1) = oprtt_c2_time(i)-oprtt_c2_time(i-1);    
end

for i = 2:ttf_c1_len
    ttf_c1_diff(i-1) = ttf_c1_time(i)-ttf_c1_time(i-1);    
end

for i = 2:ttf_c2_len
    ttf_c2_diff(i-1) = ttf_c2_time(i)-ttf_c2_time(i-1);    
end

figure(11)
subplot(2,1,1)
plot(oprtt_c1_time(2:end), oprtt_c1_diff)
title('Time distance between samples for c1. Opnet vs ttf')
subplot(2,1,2)
plot(ttf_c1_time(2:end), ttf_c1_diff)

figure(12)
subplot(2,1,1)
plot(oprtt_c2_time(2:end), oprtt_c2_diff)
title('Time distance between samples for c2. Opnet vs ttf')
subplot(2,1,2)
plot(ttf_c2_time(2:end), ttf_c2_diff)

%% Plot ttf rtt estimation with counter info

ttf_c1_counter = results_cell{sim_number}.rtt_est{3}{3};
ttf_c2_counter = results_cell{sim_number}.rtt_est{4}{3};

figure(13)
subplot(2,1,1)
plot(ttf_c1_time, ttf_c1_data)
title('Ttf rtt estimation for c1. Counter info below')
subplot(2,1,2)
plot(ttf_c1_time, ttf_c1_counter)

figure(14)
subplot(2,1,1)
plot(ttf_c2_time, ttf_c2_data)
title('Ttf rtt estimation for c2. Counter info below')
subplot(2,1,2)
plot(ttf_c2_time, ttf_c2_counter)

%% Return to previous folder

cd ..
cd ..
