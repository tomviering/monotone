clear all;

addpath('helpers');
addpath('../');
addpath('../prtools');

%%

Nv_list = [5,15,25,50,100,1000];

settings.Nl = 2; % samples per class
settings.n = 150;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 100;
settings.N_testsize = 10000;

settings.learner_list = [1:3];
% 1: normal learner
% 2: monotone simple
% 3: monotone binomial test

% 4: crossval slow
% 5: crossval fast

% 6: monotone binomial test add val
% 7: monotone binomial test reuse val
% 8: monotone simple add val
% 9: monotone simple reuse val

settings.dataset_id = 1;

fn_alljobs = 'e4_Nv_peaking_tmp';
fid_alljobs = init_master(fn_alljobs);

for Nv_id = 1:6

    settings.Nv = Nv_list(Nv_id);
    
    % 1: peaking (d=200)
    % 2: random
    % 3: dipping
    settings.d_peaking = 200;

    exp_name = sprintf('%s_%d',fn_alljobs,Nv_id);
    settings_obj{Nv_id} = make_jobs(exp_name, settings, fid_alljobs);
    
end

fclose(fid_alljobs);
fprintf('\nMaster job script file written to: \n %s.sh\n\n',fn_alljobs);

%% average over multiple runs
% dim 1: n
% dim 2: learners
% dim 3: repitions
close all;

for Nv_id = 1
    
    [settings,r] = load_all(settings_obj{Nv_id});
    
    figure;
    errorbar((mean(r.xval2,3)),mean(r.error,3),std(r.error,0,3))
    %semilogx((mean(xval2,3)),mean(error,3))
    legend(r.leg)
    title(sprintf('average over multiple runs [Nv %d dataset %d]',settings.Nv,settings.dataset_id))
    xlabel('amount of training + validation samples (per claess)')

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
end

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