fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\params.txt', 'w');
%formatSpec = '%f'; %  instancia, cwnd, time
%P = textscan(fileID,formatSpec,'Delimiter','\n');
fclose(fileID);
disp('Files have been cleared')