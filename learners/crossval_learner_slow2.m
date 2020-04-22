function [w_best,info] = crossval_learner_slow2(dat, info)
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
    
    info.leg = 'crossval slow';
    if size(dat, 1)==0
        w_best = [];
        return;
    end

    d_trn = dat.a;
    c = info.c;

    nfolds = 5;
    nrep = 1;
    
    M = prcrossval(d_trn, [], nfolds, nrep);
    
    currep = 1;
    myfold = M(currep,:);
    
    trn_sizes = 5:5:floor((size(d_trn,1)/nfolds*(nfolds-1))/5)*5;
    
    c_error = nan(nfolds, length(trn_sizes));
    
    for fold = 1:nfolds
        i_tst = myfold == fold;
        i_trn = myfold ~= fold;
        
        f_trn = d_trn(i_trn == 1,:);
        f_tst = d_trn(i_tst == 1,:);
        
        for trn_size_i = 1:length(trn_sizes)
            
            trn_size = trn_sizes(trn_size_i);
            if (trn_size > size(f_trn,1))
                tmp_trn = f_trn([],:);
            else
                tmp_trn = f_trn(1:trn_size,:);
            end
            c_trn = tmp_trn*c;
            
            c_error(fold,trn_size_i) = testd(f_tst * c_trn); 
            c_keep{fold,trn_size_i} = c_trn;
            
        end
    end
    
    c_error_mean = mean(c_error,1);
    [~,best_i] = min(c_error_mean);
    
    c_best_errors = c_error(:,best_i);
    [~,best_fold] = min(c_best_errors);
    
    w_best = c_keep{best_fold,best_i}; 
   
end













