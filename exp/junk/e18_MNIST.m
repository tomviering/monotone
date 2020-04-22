clear all;

cd('/home/tom/Projects/monotone_learners/exp');
addpath('helpers');
addpath('../');
addpath('../prtools');

%%

large = 0;

if large == 1
    settings.Nl = 5; % samples per batch!
    settings.Nv = 20; 
    settings.n = 80;
else
    settings.Nl = 5; % samples per class
    settings.Nv = 20;
    settings.n = 40;
end
settings.c = fisherc;
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

fn_alljobs = 'e18_MNIST_small';
fid_alljobs = init_master(fn_alljobs);
fast_jobs_all = '';

for dataset_id = 4
    
    settings.dataset_id = dataset_id;
    
    % 1: peaking (d=200)
    % 2: random
    % 3: dipping
    settings.d_peaking = 500;
    
    exp_name = sprintf('%s',fn_alljobs);

    [settings_obj{dataset_id},fast_jobs] = make_jobs(exp_name, settings, fid_alljobs);
    fast_jobs_all = [fast_jobs_all,fast_jobs];
    
end
    
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

%% influence of NV on simple

%save('e18_settings','settings_obj')

conf_id = 1;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 1;

[settings,r] = load_all(settings_obj{4});
addtoplot(r,1:6,'',count_validation_data);

%title(sprintf('confidence level %g',settings.confidence_level));

%% average over multiple runs
% dim 1: n
% dim 2: learners
% dim 3: repitions
close all;
clc;
for Nv_id = 3
    
    [~,r] = load_all(settings_obj{4});
    
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
    
    AULC(Nv_id,:) = mean(mean(r.error(rounds,:,:),1),3);
    
    fprintf('dataset %d, Nv=%d\n',settings.dataset_id,settings.Nv);
    %         1 normal learner           : 
    fprintf('%2d %-40s: % 8s\t% 8s\t% 8s \n',0,'','#non-mon.','frac','AULC');
    for i = 1:length(r.leg)
        fprintf('%2d %-40s: % 8g \t % 8.2g \t % 8.2g \n',i,r.leg{i},(avg_non_monotone(i)),avg_non_monotone_frac(i),AULC(Nv_id,i));
    end
    fprintf('out of %d rounds\n',n);
    
    Nv_list2(Nv_id) = settings.Nv;
    avg_non_monotone_all(Nv_id,:) = avg_non_monotone;
end

%% # Monotone

figure;
semilogx(repmat(Nv_list2',1,size(avg_non_monotone_all,2)),avg_non_monotone_all/n,'*-')
legend(r.leg)

ylabel('#non-monotone transitions')
xlabel('validation set size (per class)')

%% AULC

figure;
semilogx(repmat(Nv_list2',1,size(AULC,2)),AULC,'*-')
legend(r.leg)

ylabel('AULC')
xlabel('validation set size (per class)')

%% Cost
% could make a cost graph, where cost on x-axis
C = 0.01;
cost = avg_non_monotone_all*C + AULC;

figure;
semilogx(repmat(Nv_list2',1,size(cost,2)),cost,'*-')
legend(r.leg)

ylabel(sprintf('Cost = %.3g', C))
xlabel('validation set size (per class)')