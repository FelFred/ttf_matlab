clear all
close all
clc

big_cell = cell(4,1);
th_total = zeros(4,2,9,4,4);
gp_total = zeros(2,9,4,4);
gp_ratio_total = zeros(9,4,4);
qm_total = zeros(9,4,4);
qs_total = zeros(9,4,4);
bg_array = zeros(9,1);

for i = 1:4
   
   fileName = [num2str(i) '.mat'];
   
   % Prepare variable name
   results = struct([]); % creates empty structure
   results_str = 'results';
      
   % Load structure into variable
   load(fileName, results_str);
   big_cell{i} = results;
   th = results.th{1};
   bg = results.bg{1};
   bg_array = bg;
   q_array = results.q_mean{1};
   qstd_array = results.q_std{1};
   th_total(:,:,:,:,i) = th(:,:,:,:);
   gp_total(:,:,:,i) = squeeze(th(3,:,:,:));
   gp_ratio_total(:,:,i) = squeeze(gp_total(1,:,:,i)./gp_total(2,:,:,i));
   qm_total(:,:,i) = q_array(:,:);
   qs_total(:,:,i) = qstd_array(:,:);
   
end



%% Plot data

figure(1)
xlabel('Pkt iat')
ylabel('Goodput ratio (gp1/gp2)')
plot(bg_array, gp_ratio_total(:,1,1), 'b*-')
title('Fairness per simulation')
hold on
plot(bg_array, gp_ratio_total(:,2,1), 'bx-')
plot(bg_array, gp_ratio_total(:,3,1), 'b*--')
plot(bg_array, gp_ratio_total(:,4,1), 'bx--')
% pause(5)

plot(bg_array, gp_ratio_total(:,1,2), 'r*-')
plot(bg_array, gp_ratio_total(:,2,2), 'rx-')
plot(bg_array, gp_ratio_total(:,3,2), 'r*--')
plot(bg_array, gp_ratio_total(:,4,2), 'rx--')
% pause(5)

plot(bg_array, gp_ratio_total(:,1,3), 'k*-')
plot(bg_array, gp_ratio_total(:,2,3), 'kx-')
plot(bg_array, gp_ratio_total(:,3,3), 'k*--')
plot(bg_array, gp_ratio_total(:,4,3), 'kx--')
% pause(5)

plot(bg_array, gp_ratio_total(:,1,4), 'm*-')
plot(bg_array, gp_ratio_total(:,2,4), 'mx-')
plot(bg_array, gp_ratio_total(:,3,4), 'm*--')
plot(bg_array, gp_ratio_total(:,4,4), 'mx--')
plot(bg_array, ones(length(bg_array),1), 'r--')
% pause(5)
%ylim([0.8 1.3])

figure(2)
plot(gp_total(2,:,1,1), gp_total(1,:,1,1), 'b*-', 'MarkerSize', 10)
hold on
plot(gp_total(2,:,2,1), gp_total(1,:,2,1), 'bx-', 'MarkerSize', 10)
plot(gp_total(2,:,3,1), gp_total(2,:,3,1), 'b*--', 'MarkerSize', 10)
plot(gp_total(2,:,4,1), gp_total(2,:,4,1), 'bx--', 'MarkerSize', 10)
% pause()

plot(gp_total(2,:,1,3), gp_total(1,:,1,2), 'r*-', 'MarkerSize', 10)
plot(gp_total(2,:,2,2), gp_total(1,:,2,2), 'rx-', 'MarkerSize', 10)
plot(gp_total(2,:,3,2), gp_total(2,:,3,2), 'r*--', 'MarkerSize', 10)
plot(gp_total(2,:,4,2), gp_total(2,:,4,2), 'rx--', 'MarkerSize', 10)
% pause()

plot(gp_total(2,:,1,3), gp_total(1,:,1,3), 'k*-', 'MarkerSize', 10)
plot(gp_total(2,:,2,3), gp_total(1,:,2,3), 'kx-', 'MarkerSize', 10)
plot(gp_total(2,:,3,3), gp_total(2,:,3,3), 'k*--', 'MarkerSize', 10)
plot(gp_total(2,:,4,3), gp_total(2,:,4,3), 'kx--', 'MarkerSize', 10)
% pause()

plot(gp_total(2,:,1,4), gp_total(1,:,1,4), 'm*-', 'MarkerSize', 10)
plot(gp_total(2,:,2,4), gp_total(1,:,2,4), 'mx-', 'MarkerSize', 10)
plot(gp_total(2,:,3,4), gp_total(2,:,3,4), 'm*--', 'MarkerSize', 10)
plot(gp_total(2,:,4,4), gp_total(2,:,4,4), 'mx--', 'MarkerSize', 10)
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
% errorbar(bg_array, q_array(:,1,1), qstd_array(:,1,1), 'b*-')
% title('Average queue vs pkt_iat');
% hold on
% errorbar(bg_array, qm_total(:,2,1), qs_total(:,2,1), 'bx-')
% errorbar(bg_array, qm_total(:,3,1), qs_total(:,3,1), 'b*--')
% errorbar(bg_array, qm_total(:,4,1), qs_total(:,4,1), 'bx--')
% 
% errorbar(bg_array, qm_total(:,1,2), qs_total(:,1,2), 'r*-')
% errorbar(bg_array, qm_total(:,2,2), qs_total(:,2,2), 'rx-')
% errorbar(bg_array, qm_total(:,3,2), qs_total(:,3,2), 'r*--')
% errorbar(bg_array, qm_total(:,4,2), qs_total(:,4,2), 'rx--')
% 
% errorbar(bg_array, qm_total(:,1,3), qs_total(:,1,3), 'k*-')
% errorbar(bg_array, qm_total(:,2,3), qs_total(:,2,3), 'kx-')
% errorbar(bg_array, qm_total(:,3,3), qs_total(:,3,3), 'k*--')
% errorbar(bg_array, qm_total(:,4,3), qs_total(:,4,3), 'kx--')
% 
% errorbar(bg_array, qm_total(:,1,4), qs_total(:,1,4), 'm*-')
% errorbar(bg_array, qm_total(:,2,4), qs_total(:,2,4), 'mx-')
% errorbar(bg_array, qm_total(:,3,4), qs_total(:,3,4), 'm*--')
% errorbar(bg_array, qm_total(:,4,4), qs_total(:,4,4), 'mx--')

plot(bg_array, q_array(:,1,1), 'b*-')
title('Average queue vs pkt_iat');
hold on
plot(bg_array, qm_total(:,2,1), 'bx-')
plot(bg_array, qm_total(:,3,1), 'b*--')
plot(bg_array, qm_total(:,4,1), 'bx--')

plot(bg_array, qm_total(:,1,2), 'r*-')
plot(bg_array, qm_total(:,2,2), 'rx-')
plot(bg_array, qm_total(:,3,2), 'r*--')
plot(bg_array, qm_total(:,4,2), 'rx--')

plot(bg_array, qm_total(:,1,3), 'k*-')
plot(bg_array, qm_total(:,2,3), 'kx-')
plot(bg_array, qm_total(:,3,3), 'k*--')
plot(bg_array, qm_total(:,4,3), 'kx--')

plot(bg_array, qm_total(:,1,4), 'm*-')
plot(bg_array, qm_total(:,2,4), 'mx-')
plot(bg_array, qm_total(:,3,4), 'm*--')
plot(bg_array, qm_total(:,4,4), 'mx--')


figure(4)
plot(bg_array, gp_total(2,:,1,1)+ gp_total(1,:,1,1), 'b*-', 'MarkerSize', 10)
hold on
plot(bg_array, gp_total(2,:,2,1)+ gp_total(1,:,2,1), 'bx-', 'MarkerSize', 10)
plot(bg_array, gp_total(2,:,3,1)+ gp_total(2,:,3,1), 'b*--', 'MarkerSize', 10)
plot(bg_array, gp_total(2,:,4,1)+ gp_total(2,:,4,1), 'bx--', 'MarkerSize', 10)
pause(5)

hold off

plot(bg_array, gp_total(2,:,1,3)+ gp_total(1,:,1,2), 'r*-', 'MarkerSize', 10)
% hold on
plot(bg_array, gp_total(2,:,2,2)+ gp_total(1,:,2,2), 'rx-', 'MarkerSize', 10)
hold on
% plot(bg_array, gp_total(2,:,3,2)+ gp_total(2,:,3,2), 'r*--', 'MarkerSize', 10)
plot(bg_array, gp_total(2,:,4,2)+ gp_total(2,:,4,2), 'rx--', 'MarkerSize', 10)
pause(5)
hold off
% 
% plot(bg_array, gp_total(2,:,1,3)+ gp_total(1,:,1,3), 'k*-', 'MarkerSize', 10)
% hold on
% plot(bg_array, gp_total(2,:,2,3)+ gp_total(1,:,2,3), 'kx-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,3,3)+ gp_total(2,:,3,3), 'k*--', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,4,3)+ gp_total(2,:,4,3), 'kx--', 'MarkerSize', 10)
% pause(5)
% hold off
% 
% plot(bg_array, gp_total(2,:,1,4)+ gp_total(1,:,1,4), 'm*-', 'MarkerSize', 10)
% hold on
% plot(bg_array, gp_total(2,:,2,4)+ gp_total(1,:,2,4), 'mx-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,3,4)+ gp_total(2,:,3,4), 'm*--', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,4,4)+ gp_total(2,:,4,4), 'mx--', 'MarkerSize', 10)
title('Total goodput')
legend('TTF')
hold off

figure(6)
plot(bg_array, gp_total(2,:,4,3) ./ gp_total(2,:,2,3), 'b*-', 'MarkerSize', 10)
hold on
plot(bg_array, gp_total(1,:,2,3) ./ gp_total(1,:,4,3), 'bx-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,3,1)+ gp_total(2,:,3,1), 'b*--', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,4,1)+ gp_total(2,:,4,1), 'bx--', 'MarkerSize', 10)
% pause()
% 
% plot(bg_array, gp_total(2,:,2,2)+ gp_total(2,:,4,2), 'r*-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,2,2)+ gp_total(1,:,2,2), 'rx-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,3,2)+ gp_total(2,:,3,2), 'r*--', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,4,2)+ gp_total(2,:,4,2), 'rx--', 'MarkerSize', 10)
% pause()
% 
% plot(bg_array, gp_total(2,:,1,3)+ gp_total(1,:,1,3), 'k*-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,2,3)+ gp_total(1,:,2,3), 'kx-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,3,3)+ gp_total(2,:,3,3), 'k*--', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,4,3)+ gp_total(2,:,4,3), 'kx--', 'MarkerSize', 10)
% pause()
% 
% plot(bg_array, gp_total(2,:,1,4)+ gp_total(1,:,1,4), 'm*-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,2,4)+ gp_total(1,:,2,4), 'mx-', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,3,4)+ gp_total(2,:,3,4), 'm*--', 'MarkerSize', 10)
% plot(bg_array, gp_total(2,:,4,4)+ gp_total(2,:,4,4), 'mx--', 'MarkerSize', 10)
 title('Total goodput')
% legend('TTF')
 hold off


