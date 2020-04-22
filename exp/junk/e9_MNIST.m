clear all;
clc;

cd('/home/tom/Projects/monotone_learners/exp');
addpath('helpers');
addpath('../');
addpath('../prtools');

%%

force_redo = 1;

settings.Nl = 300; % samples per class
settings.n = 20;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 5;
settings.N_testsize = -1; 

regularizers = 10.^[-5:0.5:5];
settings.regularization_list = regularizers;

settings.learner_list = [1, 2, 3, 5, 6, 8, 10, 11];
%settings.learner_list = [1, 11];
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

settings.dataset_id = 4;

settings.Nv = 100;

% 1: peaking (d=200)
% 2: random
% 3: dipping
% 4: MNIST
settings.d_peaking = 200;

fn_alljobs = 'e9_MNIST';
fid_alljobs = init_master(fn_alljobs);
fast_jobs_all = '';

settings.dataset_id = 4;
    
settings.d_peaking = 500;

exp_name = sprintf('%s',fn_alljobs);
[settings_obj,fast_jobs] = make_jobs(exp_name, settings, fid_alljobs);
fast_jobs_all = [fast_jobs_all,fast_jobs];
    
fclose(fid_alljobs);

syncjobs(); 
syncsettings(); 

if length(fast_jobs_all) == 0
    fprintf('\nMaster job script file written to %s.sh\nRun command: ./%s.sh\n',fn_alljobs,fn_alljobs);
    fprintf('\nDont forget to git pull!');
else
    fprintf('\nFirst submit fast jobs:\n');
    fprintf(fast_jobs_all);
    fprintf('\nDont forget to git pull!');
end
    
%% average over multiple runs
% dim 1: n
% dim 2: learners
% dim 3: repitions
close all;

settings = load(fn_settings);
except = 'info_keep';
load(fn_res,'-regexp', ['^(?!' except ')\w']);

toshow = [1:4,7];

figure;
errorbar((mean(xval2(:,toshow,:),3)),mean(error(:,toshow,:),3),std(error(:,toshow,:),0,3))
%semilogx((mean(xval2,3)),mean(error,3))
legend(leg{toshow})
title(sprintf('average over multiple runs [dataset %d]',settings.dataset_id))
xlabel('amount of training + validation samples (per class)')
%%
n = size(non_monotone,1); % number of rounds
avg_non_monotone = mean(sum(non_monotone,1),3);

AULC(Nv_id,:) = mean(mean(error,1),3);

fprintf('dataset %d, Nv=%d\n',settings.dataset_id,settings.Nv);
%         1 normal learner           : 
fprintf('%2d %-25s: % 8s\t% 8s \n',0,'','#non-mon.','AULC');
for i = 1:length(leg)
    fprintf('%2d %-25s: % 8g \t % 8.2g \n',i,leg{i},(avg_non_monotone(i)),AULC(Nv_id,i));
end
fprintf('out of %d rounds\n',n);

Nv_list2(Nv_id) = settings.Nv;
avg_non_monotone_all(Nv_id,:) = avg_non_monotone;


%% # Monotone

figure;
semilogx(repmat(Nv_list2',1,size(avg_non_monotone_all,2)),avg_non_monotone_all/n,'*-')
legend(leg)

ylabel('#non-monotone transitions')
xlabel('validation set size (per class)')

%% AULC

figure;
semilogx(repmat(Nv_list2',1,size(AULC,2)),AULC,'*-')
legend(leg)

ylabel('AULC')
xlabel('validation set size (per class)')

%% Cost

C = 0.01;
cost = avg_non_monotone_all*C + AULC;

figure;
semilogx(repmat(Nv_list2',1,size(cost,2)),cost,'*-')
legend(leg)

ylabel(sprintf('Cost = %.3g', C))
xlabel('validation set size (per class)')