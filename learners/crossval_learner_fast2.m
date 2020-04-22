function [w_best,info] = crossval_learner_fast2(dat, info)
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
    
    info.leg = 'crossval fast';
    if size(dat, 1)==0
        w_best = [];
        return;
    end

    a_new = dat.a_new;
    d_trn = dat.a;
    
    c = info.c;
    w_best = info.w_best;
    if ~isfield(info,'w_best5')
        for i = 1:5
            w_best5{i} = w_best;
            info.w_best5 = w_best5;
        end
    end
    w_best5 = info.w_best5;

    nfolds = 5;
    nrep = 1;
    
    M = prcrossval(a_new, [], nfolds, nrep)';
    
    if ~isfield(info,'ids')
        info.ids = M;
    else
        info.ids = [info.ids;M];
    end
    
    if ~isfield(info,'reportfoldsize')
        info.reportfoldsize = 0;
    end
    
    currep = 1;
    myfold = info.ids;
    
    c_error_new = nan(nfolds, 1);
    c_error_old = nan(nfolds, 1);
    
    for fold = 1:nfolds
        i_tst = myfold == fold;
        i_trn = myfold ~= fold;
        
        f_trn = d_trn(i_trn == 1,:);
        f_tst = d_trn(i_tst == 1,:);
        
        if info.reportfoldsize
            fprintf('trn fold: %d\n',size(f_trn,1));
            fprintf('tst fold: %d\n',size(f_tst,1));
        end
        
        % train new classifier c
        c_trn = f_trn*c;
        
        w_current{fold} = c_trn;
        
        % oops, here w_best will see its own training data...!!!

        % compute errors
        c_error_new(fold) = testd(f_tst * c_trn);  % current
        c_error_old(fold) = testd(f_tst * w_best5{fold}); % best
    end
    
    first_it = (dat.i == 1);
        
    if (mean(c_error_new) <= mean(c_error_old))||(first_it) 
        % if current model is EQUAL or BETTER, return it,
        % or if we are in the first iteration, we just take the best
        % currently trained model according to the valset.
        [~,best_fold] = min(c_error_new);
        w_best = w_current{best_fold}; 
        info.w_best5 = w_current;
    else
        % error rate of previous model was better, return it
        [~,best_fold] = min(c_error_old);
        w_best = w_best5{best_fold};
        info.w_best5 = w_best5;
        return;
    end
   
end