clear all;

cd('/home/tom/Projects/monotone_learners/exp');
addpath('helpers');
addpath('../');
addpath('../prtools');

%%

Nv_list = [5]; % if Nv = 1000 it takes really long and 
% runs out of memory for some reason...
conf_list = [0.005];

settings.Nl = 2; % samples per class
settings.n = 20;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 5;
settings.N_testsize = 10000;

settings.regularization_list = [1e-2, 1e-1, 1e0, 1e1];

settings.learner_list = [1, 10, 11, 12, 13];
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

settings.Nv = 20;

% 1: peaking (d=200)
% 2: random
% 3: dipping
settings.d_peaking = 200;

exp_name = 'e13_optimalreg';

force_redo = 1;
[fn_settings, fn_res] = check_exp(exp_name, settings, force_redo);

%%

figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

[settings,r] = load_all(fn_res);
listlearners(r);
addtoplot(r,[1:5],'',count_validation_data);
%addtoplot(r,binomial,'',count_validation_data);

%% average over multiple runs
% dim 1: n
% dim 2: learners
% dim 3: repitions
close all;
r = load(fn_res);

for Nv_id = 1
    figure;
    %errorbar((mean(r.xval2,3)),mean(r.error,3),std(r.error,0,3))
    semilogx((mean(xval2,3)),mean(error,3))
    legend(r.leg)
    title(sprintf('average over multiple runs [Nv %d dataset %d]',settings.Nv,settings.dataset_id))
    xlabel('amount of training + validation samples (per claess)')

    n = size(r.non_monotone,1); % number of rounds
    avg_non_monotone = mean(sum(r.non_monotone,1),3);
    
    AULC(Nv_id,:) = mean(mean(r.error,1),3);
    
    fprintf('dataset %d, Nv=%d\n',settings.dataset_id,settings.Nv);
    %         1 normal learner           : 
    fprintf('%2d %-25s: % 8s\t% 8s \n',0,'','#non-mon.','AULC');
    for i = 1:length(r.leg)
        fprintf('%2d %-25s: % 8g \t % 8.2g \n',i,r.leg{i},(avg_non_monotone(i)),AULC(Nv_id,i));
    end
    fprintf('out of %d rounds\n',n);
    
    Nv_list2(Nv_id) = settings.Nv;
    avg_non_monotone_all(Nv_id,:) = avg_non_monotone;
end
%% influence of NV
conf_id = 3;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for Nv_id = 1:6
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    if Nv_id == 1
        addtoplot(r,normal_learner,'',count_validation_data);
    end
    addtoplot(r,binomial,sprintf('Nv=%d',settings.Nv),count_validation_data);
end

title(sprintf('confidence level %g',settings.confidence_level));

%% Influence of confidence

Nv_id = 5;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

for conf_id = 2:7
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    if conf_id == 2
        addtoplot(r,simple,'',count_validation_data, ':');
    end
    if conf_id == 2
        addtoplot(r,binomial,sprintf('alpha=%g',settings.confidence_level),count_validation_data,'b');
    else
        addtoplot(r,binomial,sprintf('alpha=%g',settings.confidence_level),count_validation_data);
    end
    
end

title(sprintf('NV %g',settings.Nv));

%% Confidence single run

r = load(fn_res);

rep = 1;
figure;

count_validation_data = 0;

skip_info = 1;

addtoplotsingle(r,[1:9],'',rep,count_validation_data);
%title(sprintf('NV %g',settings.Nv));
% error rate first it:
% 0.2355   normal learner   (trains on NV)
% 0.3146   monontone simple 
% 0.3146   monotone binomial
% 0.2261   cross val         (on folds)
% 0.3146   binom
% 0.3146   binom
% 0.3146   simple 
% 0.3146   simple
% 0.3146   normal ignores Nv

% error rate second it:

%%

conf_id = 1;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

for Nv_id = 1:6
    [settings,r] = load_all(settings_obj{Nv_id,conf_id});
    if Nv_id == 1
        addtoplot(r,normal_learner,'');
    end
    addtoplot(r,binomial,sprintf('Nv=%d',settings.Nv));
end

title(sprintf('confidence level %g',settings.confidence_level));

%% look at models



Nv_id = 1;
conf_id = 1;
skip_info = 0;
[settings,r] = load_all(settings_obj{Nv_id,conf_id},skip_info);

%% Confidence single run

rep = 1;
Nv_id = 1;
conf_id = 1;
figure;

simple = 1;
binomial = 2;
normal_learner = 3;

count_validation_data = 0;

skip_info = 0;

[settings,r] = load_all(settings_obj{Nv_id,conf_id},skip_info);

%%
figure;
addtoplotsingle(r,[1:3],'',rep,count_validation_data);

%%

r.info_keep{1,1,1}.w_best % simple
r.info_keep{1,2,1}.w_best % binomial
r.info_keep{1,3,1}.w_best % normal


%% for simple
error_total = nan(150,0,100);
leg_total = {};

for Nv_id = 1:5
    
    [settings,r] = load_all(settings_obj{Nv_id});
    
    if Nv_id == 1
        error_total = cat(2,error_total,r.error(:,[1],:));
        leg_total{end+1} = [r.leg{1}];
    end
    
    error_total = cat(2,error_total,r.error(:,[2],:));
    for i = 2
        leg_total{end+1} = [r.leg{i},sprintf('Nv=%d',settings.Nv)];
    end
end

figure;
plot(repmat(mean(mean(r.xval2,3),2),1,size(error_total,2)),mean(error_total,3))
legend(leg_total);


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

C = 0.01;
cost = avg_non_monotone_all*C + AULC;

figure;
semilogx(repmat(Nv_list2',1,size(cost,2)),cost,'*-')
legend(r.leg)

ylabel(sprintf('Cost = %.3g', C))
xlabel('validation set size (per class)')