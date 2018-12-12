%% Code description
%{
 This code was developed to process the data of a set of X simulations, where X is the number of bg traffic distributions used.
 The whole set of data comes from 1 seed.

Inputs:
- 1 specific scenario
- Y number of algorithms
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

%addpath('./funciones/');

%% Parameters

% Choose dataset manually
datasetStr = '12-Dec-2018_11-27-13';
results_path = ['./resultados/' datasetStr '/'];

% Change directory to dataset path
cd(results_path)

% Get filename base string (same as the dataset folder)
baseStr = ['./' datasetStr]; % .mat filenames initiate with the same string as the folder's name

% Get number of simulations of the dataset using dir command
datasetFiles = dir('.');
n_sim = size(datasetFiles,1) - 2; % 2 "files" would be "." and ".." in dir's output

% Other parameters
num_alg = 4; % DropTail, RED and TTF
%num_rtt = 2; % 0.15 and 0.2 for connection 2
num_bg = 9; % en teoria uno de estos 2 valores no es necesario, pues n_sim es igual a la multiplicacion de ambos
n_seeds = 3; 



%% Iterate over simulations and read structures (store in a cell) + sort data
results_cell = cell(n_sim,1);
idx_data = zeros(n_sim, 2, num_alg); % 2 = idx y bg
idx1 = 1; % indices para ir llenando muestras en arreglo
idx2 = 1;
idx3 = 1;
idx4 = 1;
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
   current_cell = results_cell{i};  
   
   % Get bg dist array
   bg_char = char(current_cell.bg_dist);
   bg_cut = bg_char(11:end-1);
   formatSpec = '%f';
   pkt_iat_cell = textscan(bg_cut, formatSpec);
   pkt_iat = pkt_iat_cell{1};
   
   % Get alg number (red = 0, red_ttf = 1, ared = 2, ared_ttf = 3)
   alg = current_cell.alg{1};
   sally_cell = current_cell.red_params{2}(4);
   sally_flag = sally_cell{1};
    
   if (strcmp(alg,'RED'))
      if (sally_flag)
        idx_data(idx1,:, 1) = [i, pkt_iat];
        idx1 = idx1 + 1;
      else
        idx_data(idx2,:, 2) = [i, pkt_iat];
        idx2 = idx2 + 1;
      end
   elseif (strcmp(alg,'TTF'))       
      if (sally_flag)
        idx_data(idx3,:, 3) = [i, pkt_iat];
        idx3 = idx3 + 1;
      else
        idx_data(idx4,:, 4) = [i, pkt_iat]; 
        idx4 = idx4 + 1;
      end
   end 
   
     
end

%% Get cell with indexes of sorted data for each algorithm
cd ..
cd ..

addpath('./funciones/');


idx_cell = sortby_pkt_iat(idx_data, idx1, idx2, idx3, idx4);



%% Get relevant data for plots 

th_array = zeros(4,2,num_bg, n_seeds, num_alg); % 4 metrics: gp,th,eff_th,th_pkt + 2 connections + 9 simulations, each with a different bg distribution + n_seeds + num_alg algorithms
q_cell = cell(num_bg, n_seeds,num_alg);


q_array = zeros(num_bg, n_seeds, num_alg);
qstd_array = zeros(num_bg, n_seeds, num_alg);
bg_array = zeros(num_bg,1);

for a = 1:num_alg
    alg_array = idx_cell{a}{1};
    % Loop over pkt iat values
    for j=1:num_bg
       for k=1:n_seeds
           alg_idx = ((j-1)*n_seeds + k);
           current_idx = alg_array(alg_idx,1);
           current_cell = results_cell{current_idx};
           th_array(1, :, j, k, a) = [current_cell.throughput{1} current_cell.throughput{2}];
           th_array(2, :, j, k, a) = [current_cell.goodput{1} current_cell.goodput{2}];
           th_array(3, :, j, k, a) = [current_cell.th_eff{1} current_cell.th_eff{2}];
           th_array(4, :, j, k, a) = [current_cell.throughput{3} current_cell.throughput{4}];
           
           q_cell{j,k,a} = current_cell.qstats{1}{2}; % 2 is cur_qsize = instantaneous or smoothed queue size according to smoothing flag value

           % Get q data in different arrays for errorbar   (both from instantaneous measurements) 
           q_array(j,k,a) = mean(current_cell.qstats{1}{1});
           qstd_array(j,k,a) = std(current_cell.qstats{1}{1});

           % Check timeout 
           timeouts = size(current_cell.timeouts{1}{1}) - 1 + size(current_cell.timeouts{2}{1}) - 1;

           % Check if connection duration is wrong (less than 10 seconds)
           wrong_dt = (current_cell.conn_dur{1} < 10) + (current_cell.conn_dur{2} < 10);

           % Change values to NaNs if problems were detected
           if (timeouts + wrong_dt > 0) 
                th_array(:,:,j,k,a) = NaN(4,2);
                q_array(j,k,a) = NaN;
                qstd_array(j,k,a) = NaN;
           end

       end
       % Get bg dist array
       bg_char = char(current_cell.bg_dist);
       bg_cut = bg_char(11:end-1);
       formatSpec = '%f';
       pkt_iat_cell = textscan(bg_cut, formatSpec);
       pkt_iat = pkt_iat_cell{1}
       bg_array(j) = pkt_iat
    end
end
%% Get avg and std for throughput, goodput and effective_throughput
% Transform Inf to NaNs (Inf = connection failed)
th_array(th_array == Inf) = nan;

% Get matrix average over seeds dimension (ignoring NaNs)
th = squeeze(mean(th_array, 4, 'omitnan'));

    
%% Get avg and std for (avg) queue size and queueing delay(the previous "amplified" by a factor)
% alg_q_array = zeros(num_bg,n_seeds,2);
% 
% for k = 1:num_bg
%     s_mean = squeeze(mean(q_cell{k,2}))
%     alg_q_array(k,:) = [mean(q_cell{k}) std(q_cell{k})];
% end
% 
% alg_qs = mean(alg_q_array,1);
q_array = mean(q_array,2,'omitnan');
qstd_array = mean(qstd_array,2,'omitnan');
%% Get timeout data arrays
c1_timeouts = zeros(n_sim,1);
c2_timeouts = zeros(n_sim,1);
for l = 1:n_sim
    c1_timeouts(l) = length(results_cell{l}.timeouts{1}{1}) - 1;    
    c2_timeouts(l) = length(results_cell{l}.timeouts{2}{1}) - 1;
end

%% Plot data

% Plot "th1" vs "th2" (with "th" = th, gp or eff_th)
specified_alg = 3;
gp_array = squeeze(th(4,:,:,:));
figure(16)
bar(bg_array, gp_array(:,:,2)')
title('Throughput(c1,c2) for different pkt iat')
xlabel('Pkt interarrival time')
ylabel('Throughput[bits]')

tp_array = squeeze(th(3,:,:,:));
figure(1)
bar(bg_array, tp_array(:,:,specified_alg)')
title('Goodput(c1,c2) for different pkt iat')
xlabel('Simulation')
ylabel('Goodput[bits]')

gp_ratio = squeeze(gp_array(1,:,:)./gp_array(2,:,:));
figure(15)
xlabel('Simulation')
ylabel('Goodput ratio (gp1/gp2)')
plot(bg_array, gp_ratio(:,1), 'b*-')
title('Fairness per simulation')
hold on
plot(bg_array, gp_ratio(:,2), 'k*-')
plot(bg_array, gp_ratio(:,3), 'bx-')
plot(bg_array, gp_ratio(:,4), 'kx-')
plot(bg_array, ones(length(bg_array),1), 'r--')
%ylim([0.8 1.3])

figure(2)
x_plot = squeeze(th(3,2,:,1));
y_plot = squeeze(th(3,1,:,1));
plot(x_plot, y_plot, 'b-o', 'MarkerSize', 10)
hold on
x_plot = squeeze(th(3,2,:,2));
y_plot = squeeze(th(3,1,:,2));
plot(x_plot, y_plot, 'k-o', 'MarkerSize', 10)
x_plot = squeeze(th(3,2,:,3));
y_plot = squeeze(th(3,1,:,3));
plot(x_plot, y_plot, 'b-x', 'MarkerSize', 10)
x_plot = squeeze(th(3,2,:,4));
y_plot = squeeze(th(3,1,:,4));
plot(x_plot, y_plot, 'k-x', 'MarkerSize', 10)
xlim([10^5 0.5*10^7])
ylim([10^5 0.5*10^7])
title('Goodput per connection (fairness)')
plot([10^5 2*10^7], [10^5 2*10^7], 'm--')
legend('TTF')
hold off

% Plot avg queue size vs bg traffic (RED_TTF)
q_array = squeeze(q_array);
qstd_array = squeeze(qstd_array);
figure(5)
errorbar(bg_array, q_array(:,specified_alg), qstd_array(:,specified_alg))
title('Average queue vs pkt_iat');

%% Return to previous folder

% cd ..
% cd ..
