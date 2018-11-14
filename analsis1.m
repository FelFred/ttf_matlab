fileID_cnt1 = fopen('C:\cnt1_rtt.txt');
formatSpec = '%f %f'; % contador (indica cuantos paquetes tardé en medir rtt), tiempo, servidor 
cnt_cells1 = textscan(fileID_cnt1,formatSpec,'Delimiter','\n');
fclose(fileID_cnt1);

% fileID_inout1 = fopen('C:\in_out1.txt');
% formatSpec = '%f %f %f'; % in/out, time, servidor
% inout_cells1 = textscan(fileID_inout1,formatSpec,'Delimiter','\n');
% fclose(fileID_inout1);

fileID_cnt2 = fopen('C:\cnt0_rtt.txt');
formatSpec = '%f %f'; % contador (indica cuantos paquetes tardé en medir rtt), tiempo, servidor 
cnt_cells0 = textscan(fileID_cnt2,formatSpec,'Delimiter','\n');
fclose(fileID_cnt2);
% 
% fileID_inout2 = fopen('C:\in_out2.txt');
% formatSpec = '%f %f %f'; % in/out, time, servidor
% inout_cells0 = textscan(fileID_inout2,formatSpec,'Delimiter','\n');
% fclose(fileID_inout2);

cnt0_array = zeros(1,length(cnt_cells0{1}));
cnt1_array = zeros(1,length(cnt_cells1{1}));
ctime0_array = cnt0_array;
ctime1_array = cnt1_array;

for i = 1:length(cnt_cells0{1})   
    cnt0_array(i) = cnt_cells0{1}(i);
    ctime0_array(i) = cnt_cells0{2}(i);    
    
end
for i = 1:length(cnt_cells1{1})    
    cnt1_array(i) = cnt_cells1{1}(i);
    ctime1_array(i) = cnt_cells1{2}(i);     
end

% inout0_array = zeros(1,length(inout_cells0{1}));
% inout1_array = zeros(1,length(inout_cells1{1}));
% iotime0_array = inout0_array;
% iotime1_array = inout1_array;
% 
% 
% for i = 1:length(inout_cells0{1})   
%     inout0_array(i) = inout_cells0{1}(i);
%     iotime0_array(i) = inout_cells0{3}(i);    
%     
% end
% for i = 1:length(inout_cells1{1})    
%     inout1_array(i) = inout_cells1{1}(i);
%     iotime1_array(i) = inout_cells1{3}(i);     
% end

figure()
plot( ctime0_array, cnt0_array )
xlabel('Nada')
ylabel('Contador')
title('Evolucion contador, s0')

% figure()
% plot( iotime0_array, inout0_array )
% xlabel('Tiempo')
% ylabel('In/Out')
% title('InOut de paquetes desde s0')

figure()
plot( ctime1_array, cnt1_array )
xlabel('Nada')
ylabel('Contador')
title('Evolucion contador, s1')

% figure()
% plot( iotime1_array, inout1_array )
% xlabel('Tiempo')
% ylabel('In/Out')
% title('InOut de paquetes desde s1')
