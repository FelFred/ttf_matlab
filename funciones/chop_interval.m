function y = chop_interval(data_array, time_array, dt_c1, dt_c2)
    L = length(time_array);
    c1_end = dt_c1+20;
    c2_end = dt_c2+20;
    stop = min(c1_end,c2_end);
    
    begin_idx = 0;
    end_idx = 0;
    for i = 1:L
        if (begin_idx == 0)
            if (time_array(i) >= 20)
                begin_idx = i;
            end
        else
            if (time_array(i) >= stop)
                end_idx = i-1;
                break
            end           
        end       
    end
    
    chopped_array = zeros(end_idx - begin_idx + 1,1);
    chopped_time = chopped_array;
    begin_idx;
    end_idx;
    idx = 1;
    for i = begin_idx:end_idx
        chopped_array(idx) = data_array(i);
        chopped_time(idx) = time_array(i);
        idx = idx + 1;
    end
    
    y = {chopped_array, chopped_time};
    
end