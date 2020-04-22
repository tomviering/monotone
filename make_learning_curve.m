function [settings, res] = make_learning_curve(settings)
% settings
Nl = settings.Nl; % per class!! unless MNIST
Nv = settings.Nv; % per class!! unless MNIST
n = settings.n; % rounds
c = settings.c; % untrained classifier
confidence_level = settings.confidence_level; % confidence
learner_list = settings.learner_list;
repitions = settings.repitions;

if (isfield(settings,'growval')) % unused in the paper
    % growval = 1: makes Nv the same size as fold of crossval2 (but doesnt
    % work - still a bug)
    growval = settings.growval;
else
    growval = 0;
end
if (~isfield(settings,'reportfoldsize')) % for debugging
    % reports the fold size in each iteration
    settings.reportfoldsize = 0;
end

% hyperparameter object
hyp.c = c;
hyp.confidence_level = confidence_level;
hyp.regularization_list = settings.regularization_list;
hyp.reportfoldsize = settings.reportfoldsize;

% dataset settings
N_testsize = settings.N_testsize; % size of test set
dataset_id = settings.dataset_id;
switch dataset_id
    case 1
        d = settings.d_peaking;
        dat_fcn = @(N) dat_peaking(d,N); 
    case 2
        dat_fcn = @(N) dat_random(N);
    case 3
        dat_fcn = @(N) dat_dipping(N);
    case 4
        dat_fcn = @(N) dat_MNIST(N,1); % repition number is not used here...
    case 5
        dat_fcn = @(N) dat_MNIST_large(N,1); % repition number is not used here...
end
% the idea is, that by calling dat_fcn(N), you will get 
% N objects randomly sampled from the dataset that were not seen before.
% for peaking, dipping, this is N samples per class (so you will get 2*N
% samples), for MNIST you will get N samples.
% this is only for constructing the training and validation sets

if (dataset_id == 4)||(dataset_id == 5)
    dat_all = dat_fcn(-1);
    dat_empty = dat_all([],:);
    w_empty = onec(dat_all);
    clear dat_all;
else
    % initialize labeled dataset, best classifier, data iterator
    dat_empty = dat_fcn(2); % this trick doesn't work on MNIST,
    % since then we may miss classes, and also the training set shrinks...
    dat_empty = dat_empty([],:);

    w_empty = dat_empty*c;
end

learners = length(learner_list);

% if repitions is 1 number, we interpret it as the number of repitions to
% do. if it is an array, we will take the indices and perform those
% repitions.
if length(repitions) == 1
    rep_array = 1:repitions;
else
    rep_array = repitions;
end

numrep = length(rep_array);
error = nan(n,learners,numrep);
xval  = nan(n,learners,numrep);
xval2 = nan(n,learners,numrep);
non_monotone = zeros(n,learners,numrep);

print_learners = 0;

fprintf('doing repition %d to %d\n',rep_array(1),rep_array(end));

for rep_i = 1:length(rep_array)
    
    if (print_learners == 1)&&(rep_i > 1)
        continue;
    end
    
    fprintf('\nrep %d/%d\n',rep_i,numrep);
    
    tic
    for learner = 1:learners
        
        my_learner = learner_list(learner);
        switch my_learner
            case 1
                learner_fcn = @(dat, info) normal_learner2(dat, info);
            case 2
                learner_fcn = @(dat, info) monotone_learner_simple2(dat, info);
            case 3
                learner_fcn = @(dat, info) monotone_learner_binomial2(dat, info);
            case 4
                learner_fcn = @(dat, info) crossval_learner_slow2(dat, info);
            case 5 
                learner_fcn = @(dat, info) crossval_learner_fast2(dat, info);
            case 6
                learner_fcn = @(dat, info) monotone_learner_binomial2_add_val(dat, info);
            case 7
                learner_fcn = @(dat, info) monotone_learner_binomial2_reuse_val(dat, info);
            case 8
                learner_fcn = @(dat, info) monotone_learner_simple2_add_val(dat, info);
            case 9
                learner_fcn = @(dat, info) monotone_learner_simple2_reuse_val(dat, info);
            case 10
                learner_fcn = @(dat, info) optimal_regularization(dat, info);
            case 11
                learner_fcn = @(dat, info) normal_learner3(dat, info);
            case 12
                learner_fcn = @(dat, info) optimal_regularization_add_val(dat, info);
            case 13
                learner_fcn = @(dat, info) optimal_regularization_crossval_fast(dat, info);
        end
        % the idea of the learner function, is that when it is called, with
        % dat and info, it will return the new learner 
        
        % get the learner name
        [~, info] = learner_fcn([],[]);
        leg{learner} = info.leg;
        
        
        if (print_learners == 1)
            fprintf('%% %d: %s\n',learner,leg{learner});
            continue;
        end
        fprintf('learner %d/%d: %s\n',learner,learners,leg{learner});

        dat_l = dat_empty; % labeled set
        dat_v = dat_empty; % validation set
        dat_a = dat_empty; % ALL set (L + V)
        
        dat_i = 1; % keeps track of all requested samples
        w_best = w_empty; % current best model
        
        info = hyp; % get fresh hyperparameters
        info.w_best = w_best; % info.w_best keeps track of current
        % model that we will use to perform predictions
        
        rep = rep_array(rep_i);
        rng(rep); % reproduceable

        if (dataset_id == 4)||(dataset_id == 5)
            % the MNIST dataset generator depends on the repition
            % so we have to reset it here
            if (dataset_id == 4)
                dat_fcn = @(N) dat_MNIST(N, rep);
            else
                dat_fcn = @(N) dat_MNIST_large(N, rep);
            end
            dat_test = dat_fcn(-2); % gets the testset
            dat = dat_fcn;
        else
            % get dataset
            dat = dat_fcn;
            dat_test = dat_fcn(N_testsize);
        end

        for i = 1:n % iteration over number of rounds
            
            if (mod(i,1) == 0)
                fprintf('iteration %d of %d...\n',i,n);
            end
            
            dat_l_old = dat_l;   % L of previous round
            dat_l_new = dat(Nl); % newly samples to be added to L
            dat_i = dat_i+Nl;
            dat_l = [dat_l;dat_l_new]; % the new L
            
            N = size(dat_l,1) + size(dat_v,1); % training data up to now 
            % + old validation data

            dat_v_old = dat_v; % V of previous riund
            
            if (~growval) % set growval to 0, it is not used in the paper
                dat_v_new = dat(Nv); % newly samples to added to V
            else
                K = 5; % untested code, do not use
                Nv_new = round(1/(K-1)*N/2); % devide by 2 to get per class
                dat_v_new = dat(Nv_new);
            end
            dat_i = dat_i+Nv; 
            dat_v = [dat_v;dat_v_new]; % V of this round
            
            dat_a_old = dat_a; % the old A (recall A = L + V)
            dat_a = [dat_l;dat_v]; % the new A
            dat_a_new = [dat_l_new;dat_v_new]; % samples that were added to A
            
            % l: all labeled up to now
            % l_new: just newly labeled set
            % l_old: labeled set of previous it (without l_new)
            
            % v: all validation data up to now
            % v_new: just new validation data 
            % v_old: validation data that has already been used
            
            % a: is just concat of the respective l and v
            
            % put everything in the dat object
            dat_struct = struct('l',dat_l,'l_new',dat_l_new,'v',dat_v,'v_new',dat_v_new,'a',dat_a,'a_new',dat_a_new,'l_old',dat_l_old,'v_old',dat_v_old,'a_old',dat_a_old,'i',i);

            % submit to learner, and get model that we should use to do
            % predictions.
            [w_best, info] = learner_fcn(dat_struct, info); 
            % note that the info object can be used to store some
            % intermediate information between rounds for each learner.
            
            info.w_best = w_best; % update best model to model returned by learner
            
            if settings.reportfoldsize
                fprintf('trn set size: %d\n',size(dat_l,1));
                fprintf('val set size: %d\n',size(dat_v,1));
            end

            info_keep{i,learner,rep_i} = info; % for debugging
            error(i,learner,rep_i) = testc(dat_test * w_best); % compute test error
            
            if (i > 1)
                if error(i,learner,rep_i) > error(i-1,learner,rep_i)
                    non_monotone(i,learner,rep_i) = 1;
                end
            end
            
            xval(i,learner,rep_i) = i*(Nl);
            xval2(i,learner,rep_i) = i*(Nl+Nv);

        end
    end
    end_time = toc;
    reptime(rep_i) = end_time;
    
    min_remaining = round(((numrep-rep_i)*end_time)/60);
    if (min_remaining > 60)
        hour_remaining = floor(min_remaining/60);
        min_remaining = mod(min_remaining,60);
        fprintf('rep took %d seconds. estimated time remaining: %d hours %d min\n',round(end_time),hour_remaining,min_remaining);
    else
        fprintf('rep took %d seconds. estimated time remaining: %d min\n',round(end_time),min_remaining);
    end
end

res.leg = leg;
res.error = error;
res.xval = xval;
res.xval2 = xval2;
res.reptime = reptime;
res.non_monotone = non_monotone;
res.info_keep = info_keep;
