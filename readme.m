%% Making Learners (More) Monotone
%  T J Viering, A Mey, M Loog
%  IDA 2020

%% Installation
% 1) download all binary files. you will need this if:
%    - you want to run experiments on MNIST
%    - you want to reproduce the figures without rerunning all experiments
%    URL will come soon
% 2) install export_fig in the directory export_fig if: 
%    - you want to export the paper's figures to PDF
%    https://nl.mathworks.com/matlabcentral/fileexchange/23629-export_fig
% 3) install prtools in the directory prtools 
%    - if you want to run some of the experiments 
%    http://37steps.com/

%% How to use this code
% A minimal working example can be found in example.m
% it shows how to set up a small scale experiment, 
% compute the learning curves, and plot the results.

%% How to reproduce the figures of the paper from the author provided results
% run the code figures/run_all.m

%% How to see the experimental setups
% please see exp/readme.m

%% How to recompute all the results of the paper
% please see exp/readme.m

%% Folders:
% dat           datasets
% exp           experiments of the paper
% export_fig    to generate PDF's
% figures       to generate the figures of the paper
% learners      the different wrapper algorithms in the paper
% other         files that are not currently used
% ppt           files to generate figures for the slides
% prtools       toolbox for ML
% res           folder containing all the experiment results
% settings      folder containing all the experimental setups

%% Files:
% make_learning_curve.m the main function in the toolbox
% example.m             shows how to set up a simple experiment
% example_author.mat    some results provided by the author for example.m
% fisherc_tom2.m        new fixed fisher implementation for unbalanced
%                       training set + has functionality for regularization
% 

