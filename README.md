# Making Learners (More) Monotone
This repository contains the code to reproduce all of the results in our paper

Making Learners (More) Monotone

T J Viering, A Mey, M Loog, 

IDA 2020

If you found this code useful in your work, please cite our paper.

# Installation
1) clone this repository to your local machine
2) download all binary files (optional)
   - URL will come soon
   - only required if you want to run MNIST or if you want to reproduce the figures
3) install prtools in the directory 'prtools'
   - http://37steps.com/
4) install export_fig in the directory 'export_fig' (optional)
   - https://nl.mathworks.com/matlabcentral/fileexchange/23629-export_fig
   - only required if you want to reproduce the figures

# How to use this code
A minimal working example can be found in example.m
it shows how to set up a small scale experiment, 
compute the learning curves, and plot the results.

## How to reproduce the figures of the paper from the author provided results
run the code figures/run_all.m

## How to see the experimental setups
please see exp/readme.m

## How to recompute all the results of the paper
please see exp/readme.m
