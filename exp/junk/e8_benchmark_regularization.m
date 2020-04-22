clear all;

cd('/home/tom/Projects/monotone_learners/exp');
addpath('helpers');
addpath('../');
addpath('../prtools');

%%

settings.Nl = 5; % samples per class
settings.Nv = 20;
settings.n = 150;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 100;
settings.N_testsize = 10000;

regularizers = 10.^[-5:0.5:5];
settings.regularization_list = regularizers;

settings.learner_list = [10, 11];
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
% 11: normal learner (ignores val data)

fn_alljobs = 'e8_benchmark_regularization';
fid_alljobs = init_master(fn_alljobs);
fast_jobs_all = '';

for dataset_id = 1:3
    
    settings.dataset_id = dataset_id;
    
    % 1: peaking (d=200)
    % 2: random
    % 3: dipping
    settings.d_peaking = 500;

    exp_name = sprintf('%s_%d',fn_alljobs,dataset_id);
    [settings_obj{dataset_id},fast_jobs] = make_jobs(exp_name, settings, fid_alljobs);
    fast_jobs_all = [fast_jobs_all,fast_jobs];
    
end

fclose(fid_alljobs);

syncjobs(); 
syncsettings(); 

if length(fast_jobs_all) == 0
    fprintf('\nMaster job script file written to %s.sh\nRun command: ./%s.sh\n',fn_alljobs,fn_alljobs);
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
clear all;
clc;
load('e8_settings')

%% influence of NV on simple
figure;

count_validation_data = 0;

for Nv_id = 3
    [settings,r] = load_all(settings_obj{Nv_id});
    %if Nv_id == 1
    %    addtoplot(r,normal_learner,'',count_validation_data);
    %end
    
    addtoplot(r,1,'',count_validation_data, '-*r');
    addtoplot(r,2,'',count_validation_data, '-b');
    
end

%title(sprintf('confidence level %g',settings.confidence_level));


%%
for Nv_id = 3
    
    [settings,r] = load_all(settings_obj{Nv_id});
    
    figure;
    %errorbar((mean(r.xval2,3)),mean(r.error,3),std(r.error,0,3))
    plot((mean(r.xval2,3)),mean(r.error,3)) %,std(r.error,0,3))
    %semilogx((mean(xval2,3)),mean(error,3))
    legend(r.leg)
    title(sprintf('average over multiple runs [dataset %d]',settings.dataset_id))
    xlabel('amount of training + validation samples (per claess)')

    n = size(r.non_monotone,1); % number of rounds
    avg_non_monotone = mean(sum(r.non_monotone,1),3);
    avg_non_monotone_frac = mean(sum(r.non_monotone,1)/n,3);
    
    AULC(Nv_id,:) = mean(mean(r.error,1),3);
    
    fprintf('dataset %d, Nv=%d\n',settings.dataset_id,settings.Nv);
    %         1 normal learner           : 
    fprintf('%2d %-30s: % 8s\t% 8s\t% 8s \n',0,'','#non-mon.','frac','AULC');
    for i = 1:length(r.leg)
        fprintf('%2d %-30s: % 8g \t % 8.2g \t % 8.2g \n',i,r.leg{i},(avg_non_monotone(i)),avg_non_monotone_frac(i),AULC(Nv_id,i));
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