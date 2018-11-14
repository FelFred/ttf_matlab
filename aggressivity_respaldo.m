close all
clear
clc

init_time = 150;
pkt_size = 12000;

fileID = fopen('C:\aggressivity.txt');
formatSpec = '%f %f %f %f'; % red loss, occupied size, actual loss, port
P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);

% figure()
% plot(P{2}, P{3}, '.b')
% hold on
% plot(P{2}, P{1}, '.r')

L_p = length(P{3});
c1_array = zeros(1,L_p);
c2_array = c1_array;

for i = 1:length(P{3})
    if (P{4}(i) == 1)
        c1_array(i) = P{3}(i);
    else
        c2_array(i) = P{3}(i);
    end
end

figure()
plot(P{2}, c1_array, '.b')
hold on
plot(P{2}, c2_array, '.k')
hold on
plot(P{2}, P{1}, 'or')

% y = [c1_array(1); c2_array(1)];
% h = plot(P{2}(1), y);
% NameArray = {'Color','Marker', 'MarkerEdgeColor'};
% ValueArray = {'White', '.', 'b';'White', '.', 'k'};

% N = size(P{1},1);
% for n = 2:N
% %     if (P{4}(n) == 1)
% %     set(h, 'XData', P{2}(1:n), 'YData', P{3}(1:n), 'Color', 'b')
% %     else
% %     set(h, 'XData', P{2}(1:n), 'YData', P{3}(1:n), 'Color', 'k')    
% %     end
%     y_n = [c1_array(1:n); c2_array(1:n)];
%     h = plot(P{2}(1:n), y_n);
%     set(h, NameArray, ValueArray)
%     pause(0)
% %     if (n == 45263)
% %         disp('Se termin� la conexi�n 1');
% %     end
% end

% xlim([20.5 25.5])
% h2 = plot(P{2}(1), c1_array, '.b');
% % xlim([20.5 25.5])
% h3 = plot(P{2}(1), c2_array, '.k');
 
 
% N = size(P{1},1);
% for n = 2:N
%     set(h2, 'XData', P{2}(1:n), 'YData', c1_array(1:n))
%     set(h3, 'XData', P{2}(1:n), 'YData', c2_array(1:n))
%     pause(0)
%     if (n == 45263)
%         disp('Se termin� la conexi�n 1');
%     end
% end

