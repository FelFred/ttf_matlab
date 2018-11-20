x_array = [0 1];
x_array_2 = [0 1];
y_array_eff = [1 0];
y_array_fair = [0 1];

figure()
plot(x_array, y_array_eff, '--')
hold on
plot(x_array_2, y_array_fair, '--r')
plot()
hold off

% Maximum theoretical throughputs
p_intr = 0.001
max_th_c1 = 1500*(sqrt(3/(2*p_intr)))/rtt1
max_th_c2 = 1500*(sqrt(3/(2*p_intr)))/rtt2
rel_th_c1 = throughput_sim_c1/max_th_c1;
rel_th_c2 = throughput_sim_c2/max_th_c2;