%% Code description
%{
 This code was developed to process the data of a set of X simulations, where X is the number of bg traffic distributions used.
 The whole set of data comes from 1 seed.

Inputs:
- 1 specific scenario
- X pkt iat(interarrival time) values (lower values equal more pkts per second) 
- N seeds
   
Note: number of bg distributions, seeds and alg number must be manually injected into
code for now

Outputs:
- Fig 1:        Goodput (c1,c2) vs pkt_iat
- Fig 2:        Fairness graph (trajectory given by different pkt_iat values)
- Fig 5:        Average queue size errorbar plot vs pkt_iat avrg'd over seeds
- Fig 15:       Goodput ratio (gp1/gp2), avrg'd over seeds

%}

%% Clean stuff
clear all
close all
clc

%% Parameters

% Choose dataset manually
datasetStr = '05-Dec-2018_00-18-01';
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
num_bg = 9; % en teoria uno de estos 2 valores no es necesario, pues n_sim es igual a la multiplicacion de ambos
n_seeds = 5;
 
% Get extended str for filename
extStr = [baseStr ' ' num2str(num_alg) ' '];

%% Iterate over simulations and read structures (store in a cell)
results_cell = cell(n_sim,1);
for i = 1:n_sim
   % Get name from structure
   fileName = [extStr num2str(i)];
   
   % Prepare variable name
   results_struct = struct([]); % creates empty structure
   results_str = 'results_struct';
      
   % Load structure into variable
   load(fileName, results_str);
   
   % Store in cell
   results_cell{i} = results_struct;
end

%% Get relevant data for plots 

th_array = zeros(3,2,num_bg, n_seeds); % 3 metrics: gp,th,eff_th + 2 connections + 9 simulations, each with a different bg distribution
q_cell = cell(num_bg, n_seeds);


q_array = zeros(n_sim,1);
qstd_array = zeros(n_sim,1);
bg_array = zeros(n_sim,1);

% Loop over pkt iat values
for j=1:num_bg
   for k=1:num_seeds-1
       th_array(1, :, j, k) = [results_cell{j+k-1}.throughput{1} results_cell{j+k-1}.throughput{2}];
       th_array(2, :, j, k) = [results_cell{j+k-1}.goodput{1} results_cell{j+k-1}.goodput{2}];
       th_array(3, :, j, k) = [results_cell{j+k-1}.th_eff{1} results_cell{j+k-1}.th_eff{2}];
       q_cell{j,k} = results_cell{j+k-1}.qstats{1}{2}; % 2 is cur_qsize = instantaneous or smoothed queue size according to smoothing flag value
   end   
   
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

gp_ratio = gp_array(:,1)./gp_array(:,2)
figure(15)
xlabel('Simulation')
ylabel('Goodput ratio (gp1/gp2)')
bar(bg_array, gp_ratio)
title('Fairness per simulation')
hold on
plot(bg_array, ones(length(bg_array),1), 'rx--')

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

% Plot avg queue size vs bg traffic (RED_TTF)

figure(5)
errorbar(bg_array, q_array, qstd_array)
title('Average queue vs pkt_iat');

%% Return to previous folder

cd ..
cd ..
