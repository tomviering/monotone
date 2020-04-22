addpath('../');
addpath('../prtools');

%%

settings.Nl = 5; % samples per class
settings.Nv = 5; % samples per class
settings.n = 100;
settings.c = fisherc;
settings.confidence_level = 0.05;
settings.repitions = 10;
settings.N_testsize = 10000;

settings.dataset_id = 3;
% 1: peaking (d=200)
% 2: random
% 3: dipping

settings.learner_list = 1;
% 1: normal learner
% 2: monotone simple
% 3: monotone binomial test

% 4: crossval slow
% 5: crossval fast

% 6: monotone binomial test add val
% 7: monotone binomial test reuse val
% 8: monotone simple add val
% 9: monotone simple reuse val

folder = '../res/';
fn = '2_datasets_dipping';
fn_settings = [folder,fn,'_settings.mat'];
fn_res = [folder,fn,'_res.mat'];

redo = 0;
if (exist(fn_res))
    other_settings = load(fn_settings);
    if (diff_settings(other_settings,settings))
        fprintf('settings differ...!\n');
        in = input('redo? Y for yes:','s');
        if (in == 'Y')
            redo = 1;
        end
    end
end

if (~exist(fn_res))||(redo == 1)
    [settings, res] = learning_curve2_strat_fcn(settings);
    save(fn_settings,'-struct','settings');
    save(fn_res,'-struct','res');
else
    fprintf('experiment already done, loading results....');
end

%% just a single realization

clearvars -except fn_res;
close all;
load(fn_res);
%%

figure;
learner_to_plot = 1; 
repeat_to_plot = 1;

plot(xval2(:,learner_to_plot,repeat_to_plot),error(:,learner_to_plot,repeat_to_plot))
hold on;
plot(xval2(:,learner_to_plot,repeat_to_plot),non_monotone(:,learner_to_plot,repeat_to_plot))
legend(leg{learner_to_plot},'non monotone decisions')

num_non_monotone = sum(non_monotone(:,learner_to_plot,repeat_to_plot));
fprintf('%d/%d non monotone decisions\n', num_non_monotone,length(non_monotone(:,learner_to_plot,repeat_to_plot)))

title('single run')
xlabel('amount of training samples + validation (per class)')

%% average over multiple runs

clc

figure;
errorbar(log10(mean(xval2,3)),mean(error,3),std(error,0,3))
%semilogx((mean(xval2,3)),mean(error,3))
legend(leg)
title('average over multiple runs')
xlabel('amount of training + validation samples (per class)')

n = size(non_monotone,1);

avg_non_monotone = mean(sum(non_monotone,1),3);
fprintf('average number of non-monotone decisions:\n');
for i = 1:length(leg)
    fprintf('%2d %-25s: %d\n',i,leg{i},round(avg_non_monotone(i)));
end
fprintf('out of %d rounds\n',n);
