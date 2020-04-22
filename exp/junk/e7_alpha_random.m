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

settings.learner_list = 6;

alpha_list = [1, 0.9, 0.5, 0.05, 0.005, 0.0005, 0.00005];

% 1: normal learner
% 2: monotone simple
% 3: monotone binomial test

% 4: crossval slow
% 5: crossval fast

% 6: monotone binomial test add val
% 7: monotone binomial test reuse val
% 8: monotone simple add val
% 9: monotone simple reuse val

fn_alljobs = 'e7_alpha_random';
fid_alljobs = init_master(fn_alljobs);

fast_jobs_all = '';

for alpha_id = 1:length(alpha_list)
    
    settings.dataset_id = 2;
    settings.confidence_level = alpha_list(alpha_id);
    
    % 1: peaking (d=200)
    % 2: random
    % 3: dipping
    settings.d_peaking = 500;

    exp_name = sprintf('%s_%d',fn_alljobs,alpha_id);
    [settings_obj{alpha_id},fast_jobs] = make_jobs(exp_name, settings, fid_alljobs);
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
end

%% average over multiple runs
% dim 1: n
% dim 2: learners
% dim 3: repitions
close all;
clc;
for alpha_id = 1:length(alpha_list)
    
    [settings,r] = load_all(settings_obj{alpha_id});
    
    figure;
    %errorbar((mean(r.xval2,3)),mean(r.error,3),std(r.error,0,3))
    plot((mean(r.xval2,3)),mean(r.error,3)) %,std(r.error,0,3))
    %semilogx((mean(xval2,3)),mean(error,3))
    legend(r.leg)
    title(sprintf('average over multiple runs [dataset %d, alpha %e]',settings.dataset_id,settings.confidence_level))
    xlabel('amount of training + validation samples (per claess)')

    n = size(r.non_monotone,1); % number of rounds
    avg_non_monotone = mean(sum(r.non_monotone,1),3);
    avg_non_monotone_frac = mean(sum(r.non_monotone,1)/n,3);
    
    AULC(alpha_id,:) = mean(mean(r.error,1),3);
    
    fprintf('dataset %d, alpha=%d\n',settings.dataset_id,settings.confidence_level);
    %         1 normal learner           : 
    fprintf('%2d %-30s: % 8s\t% 8s\t% 8s \n',0,'','#non-mon.','frac','AULC');
    for i = 1:length(r.leg)
        fprintf('%2d %-30s: % 8g \t % 8.2g \t % 8.2g \n',i,r.leg{i},(avg_non_monotone(i)),avg_non_monotone_frac(i),AULC(alpha_id,i));
    end
    fprintf('out of %d rounds\n',n);
    
    Nv_list2(alpha_id) = settings.Nv;
    avg_non_monotone_all(alpha_id,:) = avg_non_monotone;
    avg_non_monotone_frac_all(alpha_id,:) = avg_non_monotone_frac;
    alpha(alpha_id) = settings.confidence_level;
end

%% for hypothesis test
error_total = nan(150,0,100);
leg_total = {};

for alpha_id = 1:length(alpha_list)
    
    [settings,r] = load_all(settings_obj{alpha_id});
    
    error_total = cat(2,error_total,r.error(:,[1],:));
    for i = 1
        leg_total{end+1} = [r.leg{i},sprintf('alpha=%g',settings.confidence_level)];
    end
end

figure;
toplot = [1,2,3,4,5];
Xval = repmat(mean(mean(r.xval2,3),2),1,size(error_total,2));
Yval = mean(error_total,3);
plot(Xval(:,toplot),Yval(:,toplot))
legend(leg_total);

%% Alpha vs non-monotone
%figure;
%plot(alpha,avg_non_monotone_frac_all)
clc;

fprintf('alpha \t fraction of non-monotone decisions\n')
for i = 1:length(alpha_list)
    fprintf('%g \t %g\n',alpha(i),avg_non_monotone_frac_all(i));
end

%% # Monotone

figure;
semilogx(repmat(alpha',1,size(avg_non_monotone_all,2)),avg_non_monotone_all/n,'*-')
legend(r.leg)

ylabel('fraction of non-monotone transitions')
xlabel('confidence level')

%% AULC

figure;
semilogx(repmat(alpha',1,size(AULC,2)),AULC,'*-')
legend(r.leg)

ylabel('AULC')
xlabel('validation set size (per class)')

%% Cost

C = 0.0001;
cost = avg_non_monotone_all*C + AULC;

figure;
semilogx(repmat(alpha',1,size(cost,2)),cost,'*-')
legend(r.leg)

ylabel(sprintf('Cost = %.3g', C))
xlabel('validation set size (per class)')