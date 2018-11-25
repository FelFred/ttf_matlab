% Params.txt
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\params.txt', 'w');
fclose(fileID);

% Fsize files
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\fsize_c1.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\fsize_c2.txt', 'w');
fclose(fileID);

% Cwnd statistics files
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\cwndstat_c1.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\cwndstat_c2.txt', 'w');
fclose(fileID);

% Conn duration files
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\begin_end_c1.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\begin_end_c2.txt', 'w');
fclose(fileID);

disp('Files have been cleared/initialized')