# Making Learners (More) Monotone
This repository contains the code to reproduce all of the results in our paper:
[https://link.springer.com/content/pdf/10.1007%2F978-3-030-44584-3_42.pdf](https://link.springer.com/content/pdf/10.1007%2F978-3-030-44584-3_42.pdf)

Making Learners (More) Monotone

T J Viering, A Mey, M Loog, 

IDA 2020

If you found this code useful in your work, please cite our paper.

# Installation
1. Clone repository to your local PC: `git clone https://github.com/tomviering/monotone.git`.
2. Download the [author provided results](http://tomviering.nl/monotone/author_results.zip) and extract it in the main folder of the repo.
3. Download and extract [prtools](http://prtools.tudelft.nl/files/prtools.zip) in the directory 'prtools'.
4. Download the [preprocessed MNIST dataset](http://tomviering.nl/monotone/processed500.zip) and extract it in the folder 'dat' (optional: only required for MNIST experiments).
5. Download and extract [export_fig](https://nl.mathworks.com/matlabcentral/fileexchange/23629-export_fig) in the directory 'export_fig' (optional: only required for PDF figures).

# How to

## example.m

A minimal working example showing how to use this toolbox.
We set up a small scale experiment, compute the learning curves, and plot the results.

## figures/run_all.m

Reproduces all the figures in the paper from the author provided results.

## exp/readme.m

This file explains which files correspond to which experiments and figures in the paper. 
Because the experiments are very time consuming (due to 100 repitions), I provide the results for you,
but using this code you can recompute all results to check their validity. 

## Contact
If you run into any issues, you can email me: t.j.my_surname_here AT tudelft DOT nl

## License

MIT License

Copyright (c) 2020 T J Viering

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
