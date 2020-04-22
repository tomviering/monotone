function [w_best, info] = normal_learner3(dat, info)
%   trains only on training data and ignores validation data

    info.leg = 'normal learner (ignores Nv)';
    if size(dat, 1)==0
        w_best = [];
        return;
    end

    d_trn = dat.l;
    c = info.c;

    % train new classifier c
    c_trn = d_trn*c;
    
    w_best = c_trn;
   
end













