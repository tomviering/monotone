clear all;

% we tried to follow the protocol of Belkin here to prepare the dataset
% we only use less Fourier feature to ease the computational burden

load('Orig-MNIST-dataset.mat');

ynew = gnd+1;

ynew2 = zeros(length(gnd),10);
for i = 1:length(ynew)
    
    ynew2(i,ynew(i)) = 1;
    
end

%% compute random vectors

d = size(fea,2);
N = size(fea,1); 

sigma = 5;

k = 500;
rng(0);
R = randn(k,d)/(sigma);

%% normalize original features to [0,1]

max_val = repmat(max(fea),N,1);
max_val(max_val == 0) = 1;

fea = fea./max_val;

%% compute Fourier features
clear i;

fea = fea*R';
fea = i*fea;
fea = exp(fea);

fea = [real(fea),imag(fea)];

X = fea;
clear fea;
y = ynew2;

%% save extracted features

save(sprintf('processed%d.mat',2*k),'X','y','-v7.3');
clear all;


