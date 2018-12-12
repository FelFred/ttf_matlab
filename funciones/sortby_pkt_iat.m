function y = sortby_pkt_iat(idx_data, idx1, idx2, idx3, idx4)
    idx_array = [idx1, idx2, idx3, idx4];
    output_cell = cell(4,1);
    
    % Loop over algorithms
    for k = 1:4
        alg_data = idx_data(1:idx_array(k)-1, :, k);        
        [sorted, I] = sort(alg_data,1);
        
        output_array = zeros(idx_array(k)-1,2);
        
        for j = 1:idx_array(k)-1
            output_array(j,:) = alg_data(I(j,2), :);
        end
        output_cell{k} = {output_array};
    end
    
    y = output_cell;
end