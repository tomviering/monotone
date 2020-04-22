function [w_best, info] = normal_learner2(dat, info)
%   d_trn: all training data up to now
%   just trains on the training data 

    info.leg = 'normal learner';
    if size(dat, 1)==0
        w_best = [];
        return;
    end

    d_trn = dat.a;
    c = info.c;

    % train new classifier c
    c_trn = d_trn*c;
    
    w_best = c_trn;
   
end













