clear all;

addpath('helpers');
addpath('../');
addpath('../prtools');
addpath('../learners');

%%

Nv_list = [5,15,25,50,100,1000]; 
conf_list = [0.005, 0.05, 0.1, 0.25, 0.45, 0.49, 0.5];

settings.Nl = 2; % samples per class
settings.n = 150;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 100;
settings.N_testsize = 10000;

settings.regularization_list = [];

settings.learner_list = [2,3,11];
% 1: normal learner
% 2: monotone simple
% 3: monotone binomial test

% 4: crossval slow
% 5: crossval fast

% 6: monotone binomial test add val
% 7: monotone binomial test reuse val
% 8: monotone simple add val
% 9: monotone simple reuse val

% 10: optimal regularization
% 11: train on training data only

settings.dataset_id = 1;

fast_jobs_all = '';

fn_alljobs = 'e10_Nv_peaking';
fid_alljobs = init_master(fn_alljobs);

for Nv_id = 1:length(Nv_list)
    
    for conf_id = 1:length(conf_list)

        settings.Nv = Nv_list(Nv_id);
        settings.confidence_level = conf_list(conf_id);

        % 1: peaking (d=200)
        % 2: random
        % 3: dipping
        settings.d_peaking = 200;

        exp_name = sprintf('%s_%d_%d',fn_alljobs,Nv_id,conf_id);
        %[fn_settings{Nv_id}, fn_res{Nv_id}] = check_exp(exp_name, settings);
        %settings_obj{Nv_id} = make_jobs(exp_name, settings, fid_alljobs);
        
        [settings_obj{Nv_id,conf_id},fast_jobs] = make_jobs(exp_name, settings, fid_alljobs);
        fast_jobs_all = [fast_jobs_all,fast_jobs];

    end
    
end
    
%% 



