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
datasetStr = '31-Jan-2019_15-20-26';
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
bg_end = 1000; % manual input of bg traffic end



%% Iterate over simulations and read structures (store in a cell) + sort data
bgend_array = zeros(1,n_sim);
results_cell = cell(n_sim,1);
problematic = zeros(n_sim,1);
wrong_dur = zeros(n_sim,1); 
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
   
   % Get bg_end time
   bgend_array(i) = current_cell.bg{1}{1};
    
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
expected_array = zeros(num_bg,n_seeds, num_alg);
empiric_array = zeros(num_bg,n_seeds, num_alg);
dt_array = zeros(2,num_bg, n_seeds, num_alg);
dt_array2 = zeros(2,num_bg, n_seeds, num_alg);


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
           
           if (j == 9)
               current_idx;
           end

          
           
           % Get data for loss ratio plot
           expected_array(j,k,a) = (current_cell.rtts{2}/current_cell.rtts{1})^2; 
           empiric_array(j,k,a) = current_cell.loss{1}/current_cell.loss{2};
           
           % Get data for connection duration
           dt_array(1,j,k,a) = current_cell.conn_dur{1}; % using conn_dur values
           dt_array(2,j,k,a) = current_cell.conn_dur{2};
           
           % Force connection duration using last value of cwnd
           dt_array2(1,j,k,a) = current_cell.cwnd{2}{2}(end)-20; % using cwnd data           
           dt_array2(2,j,k,a) = current_cell.cwnd{1}{2}(end)-20;     
           
           % Get chopped array of qstats in the interval where both
           % connections are alive
           q_chopped = chop_interval(current_cell.qstats{1}{1}, current_cell.qstats{1}{4}, dt_array2(1,j,k,a), dt_array2(2,j,k,a));
           qdata_chopped = q_chopped{1};
           
           % Get q data in different arrays for errorbar   (both from instantaneous measurements) 
           q_array(j,k,a) = mean(qdata_chopped);
           qstd_array(j,k,a) = std(qdata_chopped);
           
           % Get q data in different arrays for errorbar   (both from instantaneous measurements) 
%            q_array(j,k,a) = mean(current_cell.qstats{1}{1});
%            qstd_array(j,k,a) = std(current_cell.qstats{1}{1});
%            
           

           % Check timeout 
%            timeouts = length(current_cell.timeouts{1}{1}) - 1 + length(current_cell.timeouts{2}{1}) - 1;
           timeouts = 0; % ya que son pocos, las simulaciones con timeouts se tomarán en cuenta

           % Check if connection duration is wrong (less than 10 seconds)
           wrong_dt = (current_cell.conn_dur{1} < 10) + (current_cell.conn_dur{2} < 10);
           if (wrong_dt > 0)
                wrong_dur(current_idx) = wrong_dt;
           end
           wrong_dt = 0; %ya que con segundo método se logra medir bien duracion de conexiones
           

           % Change values to NaNs if problems were detected
           if (timeouts + wrong_dt > 0) 
                th_array(:,:,j,k,a) = NaN(4,2);
                q_array(j,k,a) = NaN;
                qstd_array(j,k,a) = NaN;
%                 expected_array(j,k,a) = NaN;
                empiric_array(j,k,a) = NaN;
                problematic(current_idx) = 1;
                dt_array(1,j,k,a) = NaN;
                dt_array(2,j,k,a) = NaN;
           end 
           
           
           
       end
       % Get bg dist array
       bg_char = char(current_cell.bg_dist);
       bg_cut = bg_char(11:end-1);
       formatSpec = '%f';
       pkt_iat_cell = textscan(bg_cut, formatSpec);
       pkt_iat = pkt_iat_cell{1};
       bg_array(j) = pkt_iat;
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

%% Get avg for loss ratio arrays
expected_lr = squeeze(mean(expected_array, 2, 'omitnan'));
empiric_lr = squeeze(mean(empiric_array, 2, 'omitnan'));

%% Get avg for connection duration arrays
dt_avg = squeeze(mean(dt_array, 3, 'omitnan'));

%% Get timeout data arrays
c1_timeouts = zeros(n_sim,1);
c2_timeouts = zeros(n_sim,1);
for l = 1:n_sim
    c1_timeouts(l) = length(results_cell{l}.timeouts{1}{1}) - 1;    
    c2_timeouts(l) = length(results_cell{l}.timeouts{2}{1}) - 1;
end

%% Get duploss per sim
c1_duploss = zeros(n_sim,1);
c2_duploss = zeros(n_sim,1);
c1_maxdist = zeros(n_sim,1);
c2_maxdist = zeros(n_sim,1);

for l = 1:n_sim
    cc = results_cell{l};
    c1_lossdata = cc.dest{1}{1}; 
    c2_lossdata = cc.dest{2}{1};
    
    N_c1 = histc(c1_lossdata, unique(c1_lossdata));
    N_c2 = histc(c2_lossdata, unique(c2_lossdata));
    
    N1 = histc(N_c1, unique(N_c1));
    N2 = histc(N_c2, unique(N_c2));
    
    if( (max(N_c1) > 2) || (max(N_c2) > 2))
        disp('More than 2x loss!')
    end
    
    sn1 = size(N1);
    if (sn1(1)>1)
        n1_duploss = N1(2);
    else
        n1_duploss = 0;
    end   
    
    sn2 = size(N2);
    if (sn2(1)>1)
        n2_duploss = N2(2);
    else
        n2_duploss = 0;
    end
    
    %n2_duploss = N2(2); % se asume que el segundo hará referencia al segundo y ultimo valor de N_c1 o N_c2. no deberian haber triple perdidas y perdidas unicas son inevitables
    
    if (n1_duploss > 0)
        dup_idx1 = zeros(n1_duploss,1);
        idx1 = 1;
        distances1 = zeros(n1_duploss,1);
        
        % Look up for the indices of seq numbers which had 2x losses
        for i = 1:length(N_c1)
            if (N_c1(i) > 1)
                dup_idx1(idx1) = i;
                idx1 = idx1 + 1;
            end
        end
        
        % Iterate over duplosses to fill distance array
        index1 = 0;
        index2 = 0;
        for k = 1:n1_duploss
            value = c1_lossdata(dup_idx1(k));
            first = 1;
            for i = 1:length(c1_lossdata)
                if(c1_lossdata(i) == value)
                    if (first)
                        index1 = i;
                        first = 0;
                    else
                        index2 = i;
                    end
                end
            end
            distances1(k) = index2-index1;
        end
        
        
    else
        
        distances1 = [0];
        
    end
    
    if (n2_duploss > 0)
        dup_idx2 = zeros(n2_duploss,1);
        idx2 = 1;
        distances2 = zeros(n2_duploss,1);
        
        % Same for c2
        for i = 1:length(N_c2)
            if (N_c2(i) > 1)
                dup_idx2(idx2) = i;
                idx2 = idx2 + 1;
            end
        end
    
        % Same for c2
        index1 = 0;
        index2 = 0;
        for k = 1:n2_duploss
            value = c2_lossdata(dup_idx2(k));
            first = 1;
            for i = 1:length(c2_lossdata)
                if(c2_lossdata(i) == value)
                    if (first)
                        index1 = i;
                        first = 0;
                    else
                        index2 = i;
                    end
                end
            end
            distances2(k) = index2-index1;
    end    
    
        
    else
        distances2 = [0];
    end
       
    c1_maxdist(l) = max(distances1);
    c2_maxdist(l) = max(distances2);
    c1_duploss(l) = n1_duploss;    
    c2_duploss(l) = n2_duploss;
end


%% Plot data

% Plot "th1" vs "th2" (with "th" = th, gp or eff_th)
specified_alg = 3;
th_metric = 4;
gp_array = squeeze(th(th_metric,:,:,:));
figure(1)
bar(bg_array, gp_array(:,:,1)')
title('Throughput(c1,c2) for different pkt iat')
xlabel('Pkt interarrival time')
ylabel('Throughput[bits]')

tp_array = squeeze(th(4,:,:,:));
figure(2)
bar(bg_array, tp_array(:,:,3)')
title('Goodput(c1,c2) for different pkt iat')
xlabel('Simulation')
ylabel('Goodput[bits]')

gp_ratio = squeeze(gp_array(1,:,:)./gp_array(2,:,:));
figure(3)
xlabel('Simulation')
ylabel('Goodput ratio (gp1/gp2)')
plot(bg_array, gp_ratio(:,1), 'bx-')
title('Fairness per simulation')
hold on
plot(bg_array, gp_ratio(:,2), 'kx-')
plot(bg_array, gp_ratio(:,3), 'bo-')
plot(bg_array, gp_ratio(:,4), 'ko-')
legend('ARED','RED','ARED - TTF','RED - TTF')
plot(bg_array, ones(length(bg_array),1), 'r--')
xlabel('Packet Interarrival Time [s]')
ylabel('Goodput Ratio (Gp1/Gp2)')

%ylim([0.8 1.3])

figure(4)
x_plot = squeeze(th(th_metric,2,:,1));
y_plot = squeeze(th(th_metric,1,:,1));
plot(x_plot, y_plot, 'bx-', 'MarkerSize', 10)
hold on
x_plot = squeeze(th(th_metric,2,:,2));
y_plot = squeeze(th(th_metric,1,:,2));
plot(x_plot, y_plot, 'kx-', 'MarkerSize', 10)
x_plot = squeeze(th(th_metric,2,:,3));
y_plot = squeeze(th(th_metric,1,:,3));
plot(x_plot, y_plot, 'b.-', 'MarkerSize', 10)
x_plot = squeeze(th(th_metric,2,:,4));
y_plot = squeeze(th(th_metric,1,:,4));
plot(x_plot, y_plot, 'k.-', 'MarkerSize', 10)
max_array = [th(th_metric,2,num_bg,1) th(th_metric,1,num_bg,1) th(th_metric,2,num_bg,2) th(th_metric,1,num_bg,2) th(th_metric,2,num_bg,3) th(th_metric,1,num_bg,3) th(th_metric,2,num_bg,4) th(th_metric,1,num_bg,4)];
limit = 1.25 * max(max_array);
xlim([10^5 limit]) % 10^5 0.3*10^7 para 50-150 y 75-125
ylim([10^5 limit])
title('Goodput per connection (fairness plane)')
legend('ARED','RED','ARED - TTF','RED - TTF')
xlabel('Goodput c2')
ylabel('Goodput c1')

plot([10^5 2*10^7], [10^5 2*10^7], 'm--')
hold off

% Plot total goodput
total_gp = zeros(num_bg, 4);
for j = 1:num_bg
    for a = 1:4
        total_gp(j,a) = gp_array(1,j,a) + gp_array(2,j,a);
    end
end

figure(30)
plot(bg_array, total_gp(:,1), 'bx-')
title('Total goodput')
hold on
plot(bg_array, total_gp(:,2), 'rx-')
plot(bg_array, total_gp(:,3), 'bo--')
plot(bg_array, total_gp(:,4), 'ro--')
legend('ARED','RED','ARED - TTF','RED - TTF')
xlabel('Packet Interarrival Time [s]')
ylabel('Gp1 + Gp2')

% Plot avg queue size vs bg traffic (RED_TTF)
q_array = squeeze(q_array);
qstd_array = squeeze(qstd_array);
figure(5)
% errorbar(bg_array, q_array(:,1), qstd_array(:,1), 'bx')
plot(bg_array, q_array(:,1), 'bx-')
title('Average queue vs pkt interarrival time');
hold on
% errorbar(bg_array, q_array(:,2), qstd_array(:,2),'kx')
% errorbar(bg_array, q_array(:,3), qstd_array(:,3),'mo')
% errorbar(bg_array, q_array(:,4), qstd_array(:,4),'ro')
plot(bg_array, q_array(:,2),'kx-')
plot(bg_array, q_array(:,3),'bo--')
plot(bg_array, q_array(:,4),'ko--')
xlabel('Packet Interarrival Time [s]')
ylabel('Avg Queue size [pkts]')
legend('ARED','RED','ARED - TTF','RED - TTF')

% Plot avg queue size STD vs bg traffic (RED_TTF)
q_array = squeeze(q_array);
qstd_array = squeeze(qstd_array);
figure(6)
% errorbar(bg_array, q_array(:,1), qstd_array(:,1), 'bx')
plot(bg_array, qstd_array(:,1), 'bx-')
title('Average Queue Standard Deviation vs pkt interarrival time');
hold on
% errorbar(bg_array, q_array(:,2), qstd_array(:,2),'kx')
% errorbar(bg_array, q_array(:,3), qstd_array(:,3),'mo')
% errorbar(bg_array, q_array(:,4), qstd_array(:,4),'ro')
plot(bg_array, qstd_array(:,2),'kx-')
plot(bg_array, qstd_array(:,3),'bo--')
plot(bg_array, qstd_array(:,4),'ko--')
xlabel('Packet Interarrival Time [s]')
ylabel('Avg Queue Size Standard Deviation [pkts]')
legend('ARED','RED','ARED - TTF','RED - TTF')

% Plot experimental loss_ratio vs expected 
figure(7)
plot(bg_array, empiric_lr(:,1), 'b*-')
title('Empiric loss ratio')
hold on
plot(bg_array, empiric_lr(:,2), 'k*-')
plot(bg_array, empiric_lr(:,3), 'bx-')
plot(bg_array, empiric_lr(:,4), 'kx-')
legend('ARED','RED','ARED - TTF','RED - TTF')
plot(bg_array, expected_array(:,1), 'r--')
xlabel('Packet Interarrival Time [s]')
ylabel('Loss ratio (p1/p2)')
ylim([0 1.3*expected_array(1,1)])

% Plot TTF effect on goodput (over ARED)
ttf_effect_ared = zeros(4,num_bg);
ttf_effect_red = zeros(4,num_bg);
target_ared = zeros(2,2,num_bg);
target_red = zeros(2,2,num_bg);
delta_bg = bg_array(2)-bg_array(1);
rtt1 = results_cell{1}.rtts{1};
rtt2 = results_cell{1}.rtts{2};

for l = 1:4
    for j = 1:num_bg
        ttf_effect_ared(:,j) = [gp_array(1,j,1) gp_array(1,j,3) gp_array(2,j,1) gp_array(2,j,3)];        
        ttf_effect_red(:,j) = [gp_array(1,j,2) gp_array(1,j,4) gp_array(2,j,2) gp_array(2,j,4)];
        
        target1_ared = gp_array(1,j,1)*rtt1/0.1;
        target2_ared = gp_array(2,j,1)*rtt2/0.1;
        target1_red = gp_array(1,j,2)*rtt1/0.1;
        target2_red = gp_array(2,j,2)*rtt2/0.1;
        
        target_value_ared = (target1_ared + target2_ared)/2;
        target_value_red = (target1_red + target2_red)/2;        
%       target_value_ared = target2_ared;
%       target_value_red = target2_red;


        target_ared(:,1,j) = [bg_array(j)-delta_bg*0.3 bg_array(j)+delta_bg*0.3];
%       target_ared(:,2,j) = [bg_array(j)-delta_bg*0.3 bg_array(j)+delta_bg*0.3];
        target_ared(1,:,j) = [target_value_ared target_value_ared];        
        

        target_red(:,1,j) = [bg_array(j)-delta_bg*0.3 bg_array(j)+delta_bg*0.3];
%       target_red(:,2,j) = [bg_array(j)-delta_bg*0.3 bg_array(j)+delta_bg*0.3];
        target_red(1,:,j) = [target_value_red target_value_red];
    end
end
ttf_effect_ared = ttf_effect_ared';
ttf_effect_red = ttf_effect_red';

% Plot goodput evolution after ttf (ARED)
figure(8)
bar(bg_array, ttf_effect_ared)
title('TTF effect on goodput')
hold on
bar(bg_array,squeeze(target_ared(1,1,:)), 'FaceAlpha',0,'LineStyle', '--')
legend('ARED c1','ARED+TTF c1','ARED c2','ARED+TTF c2', 'Expected avg')
xlabel('Packet Interarrival Time [s]')
ylabel('Goodput [bits/s]')

% Plot goodput evolution after ttf (RED)
figure(15)
bar(bg_array, ttf_effect_red)
title('TTF effect on goodput')
hold on
bar(bg_array,squeeze(target_red(1,1,:)), 'FaceAlpha',0,'LineStyle', '--')
legend('RED c1','RED+TTF c1','RED c2','RED+TTF c2', 'Expected avg')
xlabel('Packet Interarrival Time [s]')
ylabel('Goodput [bits/s]')

% Plot timeouts per simulation 
figure(9)
plot(1:n_sim, c1_timeouts)
hold on
plot(1:n_sim, c2_timeouts, 'r')

% Plot 2x loss per simulation
figure(10)
plot(1:n_sim, c1_duploss)
hold on
plot(1:n_sim, c2_duploss, 'r')

% Plot 2x loss max distance per simulation
figure(11)
plot(1:n_sim, c1_maxdist)
hold on
plot(1:n_sim, c2_maxdist, 'r')

% Plot wrongdt per simulation
figure(12)
plot(1:n_sim, wrong_dur)

% Plot conn_dur evolution after TTF 
dt_aux_ared = zeros(num_bg, 4);
dt_aux_red = zeros(num_bg, 4);

for j = 1:num_bg
    dt_aux_ared(j,1) = dt_avg(1,j,1);    
    dt_aux_ared(j,2) = dt_avg(1,j,3);    
    dt_aux_ared(j,3) = dt_avg(2,j,1);    
    dt_aux_ared(j,4) = dt_avg(2,j,3);
    dt_aux_red(j,1) = dt_avg(1,j,2);    
    dt_aux_red(j,2) = dt_avg(1,j,4);    
    dt_aux_red(j,3) = dt_avg(2,j,2);    
    dt_aux_red(j,4) = dt_avg(2,j,4);
end
% ARED 
figure(13)
bar(bg_array, dt_aux_ared);
title('TTF effect on connection duration')
legend('ARED c1','ARED+TTF c1','ARED c2','ARED+TTF c2')
%plot(bg_array, expected_array(:,1), 'r--')
xlabel('Packet Interarrival Time [s]')
ylabel('Connection duration [s]')

% RED
figure(16)
bar(bg_array, dt_aux_red);
title('TTF effect on connection duration')
legend('RED c1','RED+TTF c1','RED c2','RED+TTF c2')
%plot(bg_array, expected_array(:,1), 'r--')
xlabel('Packet Interarrival Time [s]')
ylabel('Connection duration [s]')
%% Save results in .mat
f1 = 'th';
f2 = 'bg';
f3 = 'q_mean';
f4 = 'q_std';
th_cell = {{th}};
bg_cell = {{bg_array}};
qm_cell = {{q_array}};
qstd_cell = {{qstd_array}};

results = struct(f1, th_cell, f2, bg_cell, f3, qm_cell, f4, qstd_cell);

date_time = datetime('now');
DateString = datestr(date_time);
newStr = strrep(DateString,' ','_');
newStr = strrep(newStr,':','-');
algStr = num2str(4); % ocupar este numero para diferenciar resultados, debe ser el mismo que el choice (1: rtt2 = 0.1, 2: rtt2 = 0.15, 3: rtt2 = 0.2 , 4 (en otro archivo): rtt2 = 0.15 y rtt1 = 0.1)
str_2 = strcat(newStr, algStr, '.mat');
% save(str_2, 'results')

%% Return to previous folder

% cd ..
% cd ..

%% Additional stuff

% Plot connection duration vs sim number
c1_dt = zeros(n_sim,1);
c2_dt = zeros(n_sim,1);
c1_dt2 = zeros(n_sim,1); % using cwnd
c2_dt2 = zeros(n_sim,1);

for i = 1:n_sim
    c1_dt(i) = results_cell{i}.conn_dur{1};
    c2_dt(i) = results_cell{i}.conn_dur{2};    
    
    c1_dt2(i) = results_cell{i}.cwnd{2}{2}(end) - 20;
    c2_dt2(i) = results_cell{i}.cwnd{1}{2}(end) - 20;     
end

figure(14)
% plot(1:n_sim, c1_dt, 'b')

plot(1:n_sim, c1_dt2, 'b-')
hold on
% plot(1:n_sim, c2_dt, 'r')
plot(1:n_sim, c2_dt2, 'r-')
% plot(1:n_sim, (bg_end-20)*ones(n_sim,1), 'k--')
plot(1:n_sim, bgend_array, 'k--')
title('Connection duration per simulation')
legend('c1', 'c2', 'bg')
xlabel('Simulation Number')
ylabel('Connection duration [s]')

% Plot loss rate vs time and seq  number vs time for each connection
desired_cell = 108;
cc = results_cell{desired_cell};
loss_data = cc.loss_pdf{1};
c1_cnt = 0;
c2_cnt = 0;

for i = 1:length(loss_data{1})
    if (loss_data{5}(i) == 1)
        c1_cnt = c1_cnt + 1;
    elseif (loss_data{5}(i) == 3)
        c2_cnt = c2_cnt + 1;
    end
end

c1_data = zeros(c1_cnt, 5);
c2_data = zeros(c2_cnt, 5);
c1_idx = 1;
c2_idx = 1;

for i = 1:length(loss_data{1})
    if (loss_data{5}(i) == 1)
        c1_data(c1_idx,:) = [loss_data{1}(i) loss_data{2}(i) loss_data{3}(i) loss_data{4}(i) loss_data{6}(i)];
        c1_idx = c1_idx + 1;
    elseif (loss_data{5}(i) == 3)
        c2_data(c2_idx,:) = [loss_data{1}(i) loss_data{2}(i) loss_data{3}(i) loss_data{4}(i) loss_data{6}(i)];
        c2_idx = c2_idx + 1;        
    end
end

figure(40)
subplot(2,1,1)
plot(c1_data(:,4), c1_data(:,2))
subplot(2,1,2)
plot(c1_data(:,4), c1_data(:,3))
disp(['loss mean of c1: ' num2str(mean(c1_data(:,2)))])

figure(41)
subplot(2,1,1)
plot(c2_data(:,4), c2_data(:,2))
subplot(2,1,2)
plot(c2_data(:,4), c2_data(:,3))

disp(['loss mean of c2: ' num2str(mean(c2_data(:,2)))])

disp(['loss ratio: ' num2str(mean(c1_data(:,2))/mean(c2_data(:,2)))])
cc.loss


figure(42)
subplot(2,1,1)
histogram(c1_data(:,3), unique(c1_data(:,3)))
subplot(2,1,2)
histogram(c2_data(:,3), unique(c2_data(:,3)))

figure(43)
subplot(2,1,1)
hist(c1_data(:,5), unique(c1_data(:,5)))
subplot(2,1,2)
hist(c2_data(:,5), unique(c2_data(:,5)))

figure(43)
subplot(2,1,1)
plot(c1_data(:,4), c1_data(:,5))
subplot(2,1,2)
plot(c2_data(:,4), c2_data(:,5))

figure(44)

subplot(2,1,1)
plot(c1_data(:,4), c1_data(:,5))
subplot(2,1,2)
plot(c2_data(:,4), c2_data(:,5))







