% open the file
fid=fopen('C:\params.txt'); 
tline = fgetl(fid);
line_no = 1;
while ischar(tline)
    % Process current line
    switch line_no
        case 1
            formatSpec = '%f';
            line_data = textscan(tline,formatSpec);
            alg_no = line_data{1};
            switch alg_no
                case 1
                    alg_name = 'DropTail';
                case 2
                    alg_name = 'RED';
                case 3
                    alg_name = 'TTF';
                otherwise
                    disp('wrong alg_no')
            end
        case 2
            formatSpec = '%f %f';
            line_data = textscan(tline,formatSpec);
            rtt1 = line_data{1};
            rtt2 = line_data{2};
        case 3
            disp('3 is not coded yet!')
        otherwise
            disp('no use for this line')
    end
     
    % Read next line
    tline = fgetl(fid);
    line_no = line_no + 1;
end
fclose(fid);