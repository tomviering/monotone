function [w_best,info] = optimal_regularization_add_val(dat, info)
%   returns the fisher classifier with the regularization
%   that works best on the validation set
    
    info.leg = 'optimal regularization add val';
    if size(dat, 1)==0
        w_best = [];
        return;
    end
    
    d_trn = [dat.l; dat.v_old]; % append old validation data to training
    d_val = dat.v_new;
    %d_trn = dat.l;
    
    r_list = info.regularization_list;
    
    r = length(r_list);
    c_error = nan(r, 1);
    
    for i = 1:r
        
        % train new classifier c
        w = fisherc_tom2([], r_list(i));
        c_trn = d_trn*w;
        w_keep{i} = c_trn;
        
        % compute errors
        c_error(i) = testd(d_val * c_trn);  % current
    end
    
    [~,i_best] = min(c_error);
    w_best = w_keep{i_best};
   
end