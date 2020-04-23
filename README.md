# Making Learners (More) Monotone
This repository contains the code to reproduce all of the results in our paper:
[https://link.springer.com/content/pdf/10.1007%2F978-3-030-44584-3_42.pdf](https://link.springer.com/content/pdf/10.1007%2F978-3-030-44584-3_42.pdf)

Making Learners (More) Monotone

T J Viering, A Mey, M Loog, 

IDA 2020

If you found this code useful in your work, please cite our paper.

# Installation
1. Clone repository to your local PC: `git clone https://github.com/tomviering/monotone.git`
2. Download the preprocessed MNIST dataset 
3. Download the author provided results
4. Install [prtools](http://37steps.com/) in the directory 'prtools'
5) Install [export_fig](https://nl.mathworks.com/matlabcentral/fileexchange/23629-export_fig) in the directory 'export_fig' (optional: only required if you want to generate the PDF versions of the figures)

# How to use this code

## example.m

A minimal working example showing how to use this toolbox.
We set up a small scale experiment, compute the learning curves, and plot the results.

## figures/run_all.m

Reproduces all the figures in the paper from the author provided results.

## exp/readme.m

This file explains which files correspond to which experiments and figure in the paper. 
Because the experiments are very time consuming (due to 100 repitions), I provide the results for you.

