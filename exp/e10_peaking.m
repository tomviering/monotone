clear all;

addpath('helpers');
addpath('../');
addpath('../prtools');
addpath('../learners');
addpath('../dat');

%% set up the settings for the experiments

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

for Nv_id = 1:length(Nv_list)
    
    for conf_id = 1:length(conf_list)

        settings.Nv = Nv_list(Nv_id);
        settings.confidence_level = conf_list(conf_id);

        % 1: peaking (d=200)
        % 2: random
        % 3: dipping
        settings.d_peaking = 200;
        
        [~, r{Nv_id,conf_id}] = make_learning_curve(settings);
        
    end
    
end

save('r10','r');
    
%% load precomputed results by author

clear all;
load('e10_settings');

Nv_id = 1;
conf_id = 1;
[settings, r] = load_all(settings_obj{Nv_id,conf_id});

%% display all learners in the experiment

listlearners(r)

%% make a simple learning curve

figure;

simple = 1;
binomial = 2;
normal_learner = 3;

% in this experiment we don't count the validation data
count_validation_data = 0;

% perform correction
% to the x-axis (only not required for MNIST)
r.xval = r.xval*2;

% computes averaged learning curves and add them to the plot
addtoplot(r,normal_learner,'',count_validation_data,'-k');
addtoplot(r,binomial,sprintf('$N_v$=%d $\\alpha$=%g',settings.Nv,settings.confidence_level),count_validation_data,'-r');
addtoplot(r,simple,sprintf('$N_v$=%d',settings.Nv),count_validation_data,':b');

fix_legend(); % makes the legend beautiful

xlabel('training set size')
ylabel('average error rate')

