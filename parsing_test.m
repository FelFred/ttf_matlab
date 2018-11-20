% Read parameters file
% fileID = fopen('C:\params.txt');
% cur_line = fgetl(fileID);
% line_no = 1;
% while ischar(cur_line)
%     % Process current line
%     switch line_no
%         case 1
%             % Algorithm name
%             formatSpec = '%f';
%             line_data = textscan(cur_line,formatSpec);
%             alg_no = line_data{1};
%             switch alg_no
%                 case 1
%                     alg_name = 'DropTail';
%                 case 2
%                     alg_name = 'RED';
%                 case 3
%                     alg_name = 'TTF';
%                 otherwise
%                     disp('wrong alg_no')
%             end
%         case 2
%             % RTT per connection
%             formatSpec = '%f %f';
%             line_data = textscan(cur_line,formatSpec);
%             rtt1 = line_data{1};
%             rtt2 = line_data{2};
%         case 3
%             formatSpec = '%f';
%             line_data = textscan(cur_line,formatSpec);
%             p_intr = line_data{1};
%         otherwise
%             disp('no use for this line')
%     end
%      
%     % Read next line
%     cur_line = fgetl(fileID);
%     line_no = line_no + 1;
% end
% fclose(fileID);

fileID = fopen('C:\Felipe\parse_test.txt');
formatSpec = '%s'; %  instancia, cwnd, time
P = textscan(fileID,formatSpec);
text = fileread('C:\Felipe\parse_test.txt');
S = strsplit(text, 'newdata\r\n')
format = '%f %f';
d1 = textscan(S{2},format,'Delimiter','\r\n');
d2 = textscan(S{3},format,'Delimiter','\r\n');
fclose(fileID);