% This code was developed to process the data of a set of 12 simulations (3 algorithms, 2 values for RTT2 and 2 values of bg traffic interarrival time)
% The whole set of data comes from 1 seed (not clear how to read seed from opnet)

%% Parameters

% Choose dataset manually
datasetStr = '';
results_path = [',/resultados/' datasetStr '/'];

% Change directory to dataset path
cd(results_path)

% Get filename base string (same as the dataset folder)
baseStr = ['./' datasetStr]; % .mat filenames initiate with the same string as the folder's name

% Get number of simulations of the dataset using dir command
datasetFiles = dir('.');
n_sim = size(datasetFiles)(1) - 2; % 2 "files" would be "." and ".." in dir's output
 

%% Iterate over simulations

for i = 1:n_sim
    
end


