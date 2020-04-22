function [w_best,info] = optimal_regularization_crossval_fast(dat, info)
%   d_trn: all training data up to now
%   just trains on the training data 
%   slow and stupid, always redoes all computations in each round!

    % atlernatives as suggested by alexander:
    % - just keep track of all the folds, and memorize all previous
    % classifiers, than we can update their performance measure every round
    % - keep track of current best, get new folds, and evaluate new and
    % current best on the new test folds. switch if mean is better
    % 
    % - why the monotone learner doesnt reuse the val data to train on???
    % it doesnt invalidate any of the hypothesis tests!
    
    info.leg = 'optimal regularization crossval fast';
    if size(dat, 1)==0
        w_best = [];
        return;
    end

    a_new = dat.a_new;
    d_trn = dat.a;
    
    c = info.c;
    
    nfolds = 5;
    nrep = 1;
    
    M = prcrossval(a_new, [], nfolds, nrep)';
    
    if ~isfield(info,'ids')
        info.ids = M;
    else
        info.ids = [info.ids;M];
    end
    
    currep = 1;
    myfold = info.ids;
    
    r_list = info.regularization_list;
    
    
    
    
    r_num = length(r_list);
    c_error_new = nan(nfolds, r_num);
    w_keep = cell(nfolds, r_num);
    
    for fold = 1:nfolds
        i_tst = myfold == fold;
        i_trn = myfold ~= fold;
        
        f_trn = d_trn(i_trn == 1,:);
        f_tst = d_trn(i_tst == 1,:);
        
        for ri = 1:length(r_list)
            
            reg = r_list(ri);
            
            w = fisherc_tom2([], reg);
            c_trn = f_trn*w;
            
            w_keep{fold,ri} = c_trn;
        
            c_error_new(fold,ri) = testd(f_tst * c_trn);  % current
        end
    end
    
    c_error_avg = mean(c_error_new); % average out the fold
    [~,best_reg] = min(c_error_avg); % find best regularization
    
    c_error_fold = c_error_new(:,best_reg);
    [~,best_fold] = min(c_error_fold);
    
    w_best = w_keep{best_fold,best_reg};
    return;    
    
   
end