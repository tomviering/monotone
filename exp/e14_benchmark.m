clear all;

addpath('helpers');
addpath('../');
addpath('../prtools');
addpath('../learners');
addpath('../dat');

%% set up the settings

settings.Nl = 5; % samples per class
settings.Nv = 20;
settings.n = 150;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 100;
settings.N_testsize = 10000;

regularizers = 10.^[-5:0.5:5];
settings.regularization_list = regularizers;

settings.learner_list = [1,5,6,8,12,13];
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

% 12: optimal regularization val add
% 13: optimal regularization crossval fast

for dataset_id = [1,3]
    
    settings.dataset_id = dataset_id;
    
    % 1: peaking (d=200)
    % 2: random
    % 3: dipping
    settings.d_peaking = 500;
    
    [~, r{dataset_id}] = make_learning_curve(settings);
    
end

save('r14','r');

%% load precomputed results by author

clear all;
load('e14_settings')

%% make some plots
% dim 1: n
% dim 2: learners
% dim 3: repitions
close all;
clc;

for dataset_id = [1,3]
    
    [settings,r] = load_all(settings_obj{dataset_id});
    
    rounds = 1:150;
    
    figure;
    
    plot((mean(r.xval2(rounds,:,:),3)),mean(r.error(rounds,:,:),3)) %,std(r.error,0,3))
    
    legend(r.leg)
    title(sprintf('average over multiple runs [dataset %d]',settings.dataset_id))
    xlabel('amount of training + validation samples (per class)')

    n = size(r.non_monotone(rounds,:,:),1); % number of rounds
    avg_non_monotone = mean(sum(r.non_monotone(rounds,:,:),1),3);
    avg_non_monotone_frac = mean(sum(r.non_monotone(rounds,:,:),1)/n,3);
    
    AULC(dataset_id,:) = mean(mean(r.error(rounds,:,:),1),3);
    
    fprintf('dataset %d, Nv=%d\n',settings.dataset_id,settings.Nv);
    %         1 normal learner           : 
    fprintf('%2d %-40s: % 8s\t% 8s\t% 8s \n',0,'','#non-mon.','frac','AULC');
    for i = 1:length(r.leg)
        fprintf('%2d %-40s: % 8g \t % 8.2g \t % 8.2g \n',i,r.leg{i},(avg_non_monotone(i)),avg_non_monotone_frac(i),AULC(dataset_id,i));
    end
    fprintf('out of %d rounds\n',n);

end
