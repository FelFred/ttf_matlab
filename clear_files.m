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

% Loss data and total packets files
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\loss_data.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\total.txt', 'w');
fclose(fileID);

% RTT estimations files
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\oprtt_c1.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\oprtt_c2.txt', 'w');
fclose(fileID);

fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\est0.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\est.txt', 'w');
fclose(fileID);

fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\est0_v2.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\est_v2.txt', 'w');
fclose(fileID);

% Queue stats file
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\qstats.txt', 'w');
fclose(fileID);

% Remaining debt file
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\remdebt.txt', 'w');
fclose(fileID);

% Timeouts per connection files
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\timeouts_c1.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\timeouts_c2.txt', 'w');
fclose(fileID);

% Loss pdf
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\loss_pdf.txt', 'w');
fclose(fileID);
%Prints?
disp('Files have been cleared/initialized')

% bg end
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\bg_end.txt', 'w');
fclose(fileID);

% Pkt destroyed at q files
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\destroyed.txt', 'w');
fclose(fileID);
fileID = fopen('C:\\Users\\Felipe Fredes\\Documents\\opnet_res\\destroyed0.txt', 'w');
fclose(fileID);