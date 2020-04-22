clear all;

addpath('exp/helpers');
addpath('prtools');
addpath('learners');
addpath('dat');

%% set up the settings for the experiments

settings.Nl = 2; % samples per class to add in each round to labeled set
settings.Nv = 15; % samples per class to add in each round to validation set
% only for MNIST this is not per class (!)
settings.n = 150; % number of rounds
settings.c = fisherc; % the model that we train each round
settings.confidence_level = 0.05; % for the hypothesis test
settings.repitions = 5; % amount of times to repeat the experiment
settings.N_testsize = 10000; % number of test samples

settings.regularization_list = []; % required for learner 12, 13

settings.learner_list = [2,3,11]; % which learners to run, see list below

% for information which learner is which, please see
% learners/readme.m

settings.dataset_id = 1; 
% 1: peaking 
% 2: random (unused in paper)
% 3: dipping
% 4: MNIST (500 fourier features)

settings.d_peaking = 200; % dim. for peaking dataset

%% now the settings object is ready, lets run the experiment
% this computation took ~5 min on my laptop (1 repition = 1 min)

tic
[settings, r] = make_learning_curve(settings);
toc

save('example','settings','r');
    
%% load precomputed results by author

clear all;
load('example_author');

%% structure of results

% all arrays have the structure:
% dim 1: n rounds
% dim 2: learners
% dim 3: repitions

% error rates
size(r.error)

% leg gives the names of the learners

% difference between xval and xval2 is that one counts 
% validation data and the other one doesn't count it

% non_monotone: 1 if a round is not monotone (according to test data)
% 0 if monotone

% info_keep: stores all kinds of information used by the learners,
% such as the model, etc. 

% reptime: the amount of time for each repition

%% display all learners in the experiment

% with the same order as the results array
listlearners(r)

%% make a simple learning curve
% averaged over 5 runs

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

