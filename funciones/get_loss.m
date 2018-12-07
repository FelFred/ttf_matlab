function y = get_loss(q, min_th, max_p)
    max_th = 3*min_th;
	th_diff = (max_th-min_th);
	m1 = max_p/th_diff;
	n1 = max_p * (-min_th/th_diff);
	
	m2 = (1-max_p)/max_th;
	n2 = 2*max_p -1;
	
	if (q >= max_th)
		rec_red_loss = m2*q + n2;
    else
		rec_red_loss = m1*q + n1;
    end
	
    rec_red_loss(rec_red_loss < 0) = 0;
    rec_red_loss(rec_red_loss > 1) = 1;
    y = rec_red_loss;
end