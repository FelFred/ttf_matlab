function y = sortby_pkt_iat(idx_data)    
    array_size = size(idx_data);
    set_size = array_size(1);
    output_cell = cell(4,1);
    
    % Loop over algorithms
    for k = 1:4        
        alg_data = idx_data(1:set_size, :, k);        
        [sorted, I] = sort(alg_data,1);
        
        output_array = zeros(set_size,2);
        
        for j = 1:set_size
            output_array(j,:) = alg_data(I(j,2), :);
        end
        output_cell{k} = {output_array};
    end
    
    y = output_cell;
end