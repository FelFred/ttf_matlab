%% Code description


%% Pkt_iat to bg input throughput
rtt1 = 0.05;
rtt2 = 0.15;
rtt_ref = 0.1;

p_intr = 0.001;

bw = 1e8;
bg_pkt_size = 11744                                                                 % seen from queue
c_pkt_size = 12036
max_th_c1 = get_th(rtt1, p_intr)                                                    % bits/s
max_th_c2 = get_th(rtt2, p_intr)
max_wnd_c1 = max_th_c1 * rtt1 / c_pkt_size
max_wnd_c2 = max_th_c2 * rtt2 / c_pkt_size

pkt_iat_array = 1.2e-4:2e-6:1.36e-4
bg_th = bg_pkt_size ./ pkt_iat_array

figure()
plot(pkt_iat_array, bg_th)
hold on
plot(pkt_iat_array, 1e8*ones(length(pkt_iat_array),1), 'r--')
title('Bg traffic throughput')
xlabel('Packet Interarrival Time [s]')
ylabel('Bg throughput [bits/s]')
legend('Bg throughput (in)', 'Channel Capacity')


%% Get pair of RTTs so that both throughputs are at an equal distance from the target or reference throughput

% Pairs: 75-150

rtt1_array = 0.001:0.001:0.099;
rtt_ref = 0.1;
rtt2_array = zeros(length(rtt1_array),1);

for i = 1:length(rtt1_array)
    rtt2_array(i) = (2/rtt_ref - 1/rtt1_array(i))^-1;
end

figure()
plot(rtt1_array, rtt2_array)
title('Pair of RTTs at the same throughput distance from target')




