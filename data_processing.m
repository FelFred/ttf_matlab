% This code was developed to process the data of a set of 12 simulations (3 algorithms, 2 values for RTT2 and 2 values of bg traffic interarrival time)
% The whole set of data comes from 1 seed (not clear how to read seed from opnet)

clear all
close all
clc

%% Parameters

% Choose dataset manually
datasetStr = '28-Nov-2018_01-23-45';
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

%% Get relevant data

for j=1:n_sims/n_seeds
    %% Get avg and std for throughput, goodput and effective_throughput
    
    %% Get avg and std for (avg) queue size and queueing delay(the previous "amplified" by a factor)
    
    
    dt_qs = {dt_qs_avg, dt_qs_std};
    red_qs = {red_qs_avg, red_qs_std};
    ttf_qs = {ttf_qs_avg, ttf_qs_std};
    %% Get avg and std for RTT (opnet and ttf estimation)
    
    
end

%% Plot data

% Plot "th1" vs "th2" (with "th" = th, gp or eff_th)
figure()

% Plot queueing_delay / (avg) queue size for every algorithm
figure()
errorbar()

% Plot RTT for every algorithm 
figure()
errorbar()

% Plot cwnd (must be tested to achieve a meaningful figure)



%% Return to previous folder

cd ..
cd ..
