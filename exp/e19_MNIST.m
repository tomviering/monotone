clear all;

addpath('helpers');
addpath('../');
addpath('../prtools');
addpath('../learners');
addpath('../dat');

%% set up the settings

large = 0; % I never did the experiment for large = 1 ;)

if large == 1
    settings.Nl = 5; % samples per batch!
    settings.Nv = 20; 
    settings.n = 80;
else
    settings.Nl = 5; % samples per class
    settings.Nv = 20;
    settings.n = 40;
end
settings.c = fisherc_tom2([],0);
% there was a bug in fisherc for unbalanced classes, 
% so we updated it with a custom model
settings.confidence_level = 0.05;
settings.repitions = 100;
settings.N_testsize = 10000;

regularizers = 10.^[-3:1:3];
settings.regularization_list = regularizers;
settings.reportfoldsize = 0;

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
    
settings.dataset_id = 4;

[~, r] = make_learning_curve(settings);

save('r19','r');

%% load precomputed results by author

clear all;
clc;

load('e19_settings.mat');
[settings,r] = load_all(MNIST19_settings);

%% list the learners

listlearners(r);

%% make learning curve
% dim 1: n
% dim 2: learners
% dim 3: repitions
close all;

rounds = 1:40;

figure;
%errorbar((mean(r.xval2,3)),mean(r.error,3),std(r.error,0,3))
plot((mean(r.xval2(rounds,:,:),3)),mean(r.error(rounds,:,:),3)) %,std(r.error,0,3))
%semilogx((mean(xval2,3)),mean(error,3))
legend(r.leg)
title(sprintf('average over multiple runs [dataset %d]',settings.dataset_id))
xlabel('amount of training + validation samples (per claess)')

n = size(r.non_monotone(rounds,:,:),1); % number of rounds
avg_non_monotone = mean(sum(r.non_monotone(rounds,:,:),1),3);
avg_non_monotone_frac = mean(sum(r.non_monotone(rounds,:,:),1)/n,3);

AULC = mean(mean(r.error(rounds,:,:),1),3);

fprintf('dataset %d, Nv=%d\n',settings.dataset_id,settings.Nv);
%         1 normal learner           : 
fprintf('%2d %-40s: % 8s\t% 8s\t% 8s \n',0,'','#non-mon.','frac','AULC');
for i = 1:length(r.leg)
    fprintf('%2d %-40s: % 8g \t % 8.2g \t % 8.2g \n',i,r.leg{i},(avg_non_monotone(i)),avg_non_monotone_frac(i),AULC(i));
end
fprintf('out of %d rounds\n',n);



