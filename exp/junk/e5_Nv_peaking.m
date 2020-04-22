clear all;

cd('/home/tom/Projects/monotone_learners/exp');
addpath('helpers');
addpath('../');
addpath('../prtools');

%%

Nv_list = [5,15,25,50,100]; % if Nv = 1000 it takes really long and 
% runs out of memory for some reason...

settings.Nl = 2; % samples per class
settings.n = 150;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 100;
settings.N_testsize = 10000;

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

fn_alljobs = 'e5_Nv_peaking';
fid_alljobs = init_master(fn_alljobs);

for Nv_id = 1:length(Nv_list)

    settings.Nv = Nv_list(Nv_id);
    
    % 1: peaking (d=200)
    % 2: random
    % 3: dipping
    settings.d_peaking = 200;

    exp_name = sprintf('%s_%d',fn_alljobs,Nv_id);
    settings_obj{Nv_id} = make_jobs(exp_name, settings, fid_alljobs);
    
end

fclose(fid_alljobs);

syncjobs(); 
syncsettings(); 

fprintf('\nMaster job script file written to %s.sh\nRun command: ./%s.sh\n',fn_alljobs,fn_alljobs);

%% average over multiple runs
% dim 1: n
% dim 2: learners
% dim 3: repitions
close all;

for Nv_id = 1:5    
    figure;
    errorbar((mean(r.xval2,3)),mean(r.error,3),std(r.error,0,3))
    %semilogx((mean(xval2,3)),mean(error,3))
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
%% for hypothesis test
error_total = nan(150,0,100);
leg_total = {};

for Nv_id = 1:5
    
    [settings,r] = load_all(settings_obj{Nv_id});
    
    if Nv_id == 1
        error_total = cat(2,error_total,r.error(:,[1],:));
        leg_total{end+1} = [r.leg{1}];
    end
    
    error_total = cat(2,error_total,r.error(:,[3],:));
    for i = 3
        leg_total{end+1} = [r.leg{i},sprintf('Nv=%d',settings.Nv)];
    end
end

figure;
plot(repmat(mean(mean(r.xval2,3),2),1,size(error_total,2)),mean(error_total,3))
legend(leg_total);

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