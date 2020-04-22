%% experiments of the paper

% e10: Figures 1a,b,c
% e11: Figures 1d,e,f
% e14: Figures 2a,b
% e19: Figures 2c

% please make sure that the working directory of matlab is this 
% exp directory when executing the scripts. otherwise you will get an error.

%% because the experiments are very time consuming, 
% I provided the results for you. 
% eXX_settings.mat has the information necessary to load all the results
% for every experiment. see the eXX_*.m files for how to load them.

%% how to recompute just a few repitions
% I splitted the computations in parts (I split on the number of repitions)
% and ran them in parallel on our compute cluster. it is not recommended
% to run the experiments in, for example, e10 without splitting,
% as it will be extremely time consuming. you can greatly reduce the
% consumed time by reducing the amount of repitions. if you like, you can
% also set settings.repition to an array, for example, [4, 10], to only
% reproduce the results of repition 4 and 10. 

%% how to reproduce all the repitions 
% in the files above I provide the settings that are unsplitted
% you can find the splitted settings files in the folder 'settings'.
% different parts are indicated at the end.
% you will have to write some custom routines to submit them all to your
% compute cluster, but, in principle, the following lines should suffice:

% set the working directory of matlab to 'exp'. 
% execute the following commands:
%
% addpath('helpers'); 
% do_exp('../settings/e14_benchmark_1_settings_part10.mat');
% this will recompute the results of this settings file, part 10, 
% and automatically save them to the corresponding result file, in
% ../res/e14_benchmark_1_res_part10.mat

% all jobs approximately take <4 hours to run


