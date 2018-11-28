% This code was developed to process the data of a set of 12 simulations (3 algorithms, 2 values for RTT2 and 2 values of bg traffic interarrival time)
% The whole set of data comes from 1 seed (not clear how to read seed from opnet)

clear all
close all
clc

%% Parameters

% Choose dataset manually
datasetStr = '27-Nov-2018_20-28-37';
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
num_rtt = 2; % 0.15 and 0.2 for connection 2
num_bg = 2;  % constant with values: 0.00002 and 0.00001168
 

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

%% Sort structures according to parameters?


%% Plot data



%% Return to previous folder

cd ..
cd ..
