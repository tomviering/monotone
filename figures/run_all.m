
% please make sure that the working directory of matlab is this 
% figures directory. otherwise you will get an error.

%% close all figures, clean all data

clear all;
close all;
clc;

%% add required paths

addpath(genpath('../prtools'))
addpath('../exp')
addpath('../exp/helpers')
addpath('../export_fig')

%% set to 1 to dump the pdf's here

save_to_file = 0;

%% figure 1: first column

fig1_col1(save_to_file)

%% figure 1: second column

fig1_col2(save_to_file, 1) % peaking
fig1_col2(save_to_file, 0) % dipping

%% figure 1: third column

fig1_col3(save_to_file, 1) % peaking
fig1_col3(save_to_file, 0) % dipping

%% figure 2

fig2(save_to_file, 1) % peaking
fig2(save_to_file, 3) % dipping
fig2(save_to_file, 5) % MNIST

%% generate table
% generates the latex table of the paper
% and print it

benchmark_table()

