function [w_best, info] = monotone_learner_binomial2_add_val(dat, info)
%   d_trn: all training data up to now
%   d_val: fresh validationset
%   w_best: current best model
%   c: untrained classifier mapping
%   confidence_level: 

    info.leg = 'monotone binomial test add val';
    if size(dat, 1)==0
        w_best = [];
        return;
    end
    if ~isfield(info, 'mcnemar')
        info.mcnemar = false;
    end

    d_trn = [dat.l; dat.v_old];
    d_val = dat.v_new;
    w_best = info.w_best;
    
    c = info.c;
    confidence_level = info.confidence_level;

    % train new classifier c
    c_trn = d_trn*c;
    
    % if this is the first iteration, return w_1!
    if (dat.i == 1)
        w_best = c_trn;
        return;
    end
    
    % compute errors
    c_error = testd(d_val * c_trn);  % current
    b_error = testd(d_val * w_best); % best
    
    if (b_error < c_error) % error rate of previous model was better, return it
        return;
    end
    
    c_pred = labeld(d_val * c_trn);  % current
    b_pred = labeld(d_val * w_best); % best
    
    y = getlab(d_val);               % true
    
    p = test(c_pred, b_pred, y, info.mcnemar);     % signifiance test on error rate
    
    if (p < confidence_level)
        % difference seems significant, return new model
        w_best = c_trn; 
        return;
    end
    
    % difference doesn't seem significant, we don't have to update w_best
    
end













