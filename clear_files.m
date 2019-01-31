%% Specify user path
user_path = 'C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\';

% FF note - 'C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\'

%% Clear/create files

% Params.txt
fileID = fopen(strcat(user_path, 'params.txt'), 'w');
fclose(fileID);

% Fsize files
fileID = fopen(strcat(user_path, 'fsize_c1.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'fsize_c2.txt'), 'w');
fclose(fileID);

% Cwnd statistics files
fileID = fopen(strcat(user_path, 'cwndstat_c1.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'cwndstat_c2.txt'), 'w');
fclose(fileID);

% Conn duration files
fileID = fopen(strcat(user_path, 'begin_end_c1.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'begin_end_c2.txt'), 'w');
fclose(fileID);

% Loss data and total packets files
fileID = fopen(strcat(user_path, 'loss_data.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'total.txt'), 'w');
fclose(fileID);

% RTT estimations files
fileID = fopen(strcat(user_path, 'oprtt_c1.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'oprtt_c2.txt'), 'w');
fclose(fileID);

fileID = fopen(strcat(user_path, 'est0.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'est.txt'), 'w');
fclose(fileID);

fileID = fopen(strcat(user_path, 'est0_v2.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'est_v2.txt'), 'w');
fclose(fileID);

% Queue stats file
fileID = fopen(strcat(user_path, 'qstats.txt'), 'w');
fclose(fileID);

% Remaining debt file
fileID = fopen(strcat(user_path, 'remdebt.txt'), 'w');
fclose(fileID);

% Timeouts per connection files
fileID = fopen(strcat(user_path, 'timeouts_c1.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'timeouts_c2.txt'), 'w');
fclose(fileID);

% Loss pdf
fileID = fopen(strcat(user_path, 'loss_pdf.txt'), 'w');
fclose(fileID);
%Prints?
disp('Files have been cleared/initialized')

% bg end
fileID = fopen(strcat(user_path, 'bg_end.txt'), 'w');
fclose(fileID);

% Pkt destroyed at q files
fileID = fopen(strcat(user_path, 'destroyed.txt'), 'w');
fclose(fileID);
fileID = fopen(strcat(user_path, 'destroyed0.txt'), 'w');
fclose(fileID);