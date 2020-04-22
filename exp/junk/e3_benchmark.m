addpath('../');
addpath('../prtools');

%%

force_redo = 0;

settings.Nl = 5; % samples per class
settings.Nv = 25; % samples per class
settings.n = 100;
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

for d_id = 1:3

    settings.dataset_id = d_id;
    % 1: peaking (d=200)
    % 2: random
    % 3: dipping
    settings.d_peaking = 200;

    folder = '../res/';
    fn = sprintf('3_bench_%d',d_id);
    fn_settings = [folder,fn,'_settings.mat'];
    fn_res = [folder,fn,'_res.mat'];

    redo = 0;
    if (exist(fn_res))
        other_settings = load(fn_settings);
        if (~isequal(other_settings,settings))
            fprintf('settings differ...!\n');
            if (force_redo == 1)
                redo = 1;
            else
                in = input('redo? Y for yes:','s');
                if (in == 'Y')
                    redo = 1;
                end
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
end

%% just a single realization

clearvars -except fn_res;
close all;

%% average over multiple runs

for d_id = 1:3
    
    folder = '../res/';
    fn = sprintf('3_bench_%d',d_id);
    fn_settings = [folder,fn,'_settings.mat'];
    fn_res = [folder,fn,'_res.mat'];
    load(fn_res);
    
    figure;
    errorbar((mean(xval2,3)),mean(error,3),std(error,0,3))
    %semilogx((mean(xval2,3)),mean(error,3))
    legend(leg)
    title(sprintf('average over multiple runs [dataset %d]',d_id))
    xlabel('amount of training + validation samples (per class)')

    n = size(non_monotone,1);

    avg_non_monotone = mean(sum(non_monotone,1),3);
    fprintf('dataset %d\n',d_id);
    fprintf('average number of non-monotone decisions:\n');
    for i = 1:length(leg)
        fprintf('%2d %-25s: %d\n',i,leg{i},round(avg_non_monotone(i)));
    end
    fprintf('out of %d rounds\n',n);
end