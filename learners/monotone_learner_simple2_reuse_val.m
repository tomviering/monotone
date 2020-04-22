function [w_best, info] = monotone_learner_simple2_reuse_val(dat, info)
%   returns the model that performs best on validation set each time
%   d_trn: all training data up to now
%   d_val: fresh validationset
%   w_best: current best model
%   c: untrained classifier mapping
%   confidence_level: unu

    info.leg = 'monotone simple reuse val';
    if size(dat, 1)==0
        w_best = [];
        return;
    end

    d_trn = dat.l;
    d_val = dat.v;
    w_best = info.w_best;
    c = info.c;

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
    else
        % if current model is EQUAL or BETTER, return it
        w_best = c_trn; 
    end
    
end













