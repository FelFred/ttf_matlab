addpath('./funciones/');

clear all

bg_array = 1e-4*[0.1168 0.1140 0.1120 0.1100 0.1080 0.1060 0.1040 0.1020 0.1];
L = length(bg_array);
q_array = [10.7626 15.4059 18.5879 21.7501 24.8266 27.3258 28.8055 29.6554 30.1934];
loss_array = zeros(L,1);
fairness_array = zeros(L,1);
t1_array = zeros(L,1);
rtt1 = 0.1;
rtt2 = 0.15;
ref = 0.1;
rate1 = ref/rtt1;
rate2 = ref/rtt2;
p_i = 0.001;
min_th = 10;
max_p = 0.1;

for i = 1:L
    t1_array(i) = get_t1(q_array(i));
    loss_array(i) = get_loss(q_array(i), min_th, max_p);
    fairness_array(i) = (rtt2/rtt1) * sqrt((t1_array(i)*(rate2)^2*loss_array(i)+p_i)/(t1_array(i)*(rate1)^2*loss_array(i)+p_i));
end
 
figure(1)
plot(bg_array, fairness_array, '*--')
title('Analitical fairness')
xlabel('pkt iat')
ylabel('Analytical fairness')
%ylim([0.6 0.7])

q2_array = 0:1:100;
pdf_array = zeros(length(q2_array),1);
for i = 1:length(q2_array)
    pdf_array(i) = get_loss(q2_array(i), min_th, max_p);
end

figure(2)
plot(q2_array, pdf_array)