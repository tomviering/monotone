function dat = dat_MNIST(n, rep)
% rep determines the random seed for shuffling
% n = number of samples
% in special cases the counter is unaffected:
% if n = -1: return all samples (will be shuffled)
% if n = -2: return the test set (last 10 000 samples)
%            also takes into account the shuffling

    persistent X y counter my_rep;
    if (isempty(counter))
        counter = 1;
        temp = load('processed500.mat');
        X = temp.X;
        y = temp.y;
        my_rep = inf;
    end
    
    if (my_rep ~= rep)
        my_rep = rep;
        rng(my_rep);
        temp = load('processed500.mat');
        X = temp.X;
        y = temp.y;
        [~,y] = max(temp.y');
        y = y';
        myshuffle = randperm(size(X,1));
        X = X(myshuffle,:);
        y = y(myshuffle,:);
        counter = 1;
    end
        
    if (n == -1)
        dat = prdataset(X,y);
        return;
    end
    if (n == -2)
        ind = 1:size(X,1);
        ind = ind(end-10000+1:end);
        dat = prdataset(X(ind,:),y(ind));
        return;
    end
    
    ind = counter:(counter+n-1);
    counter = counter+n;
    
    if max(ind) > size(X,1)-10000
        error('out of samples... :(');
    end
    
    tempX = X(ind,:);
    tempy = y(ind,:);
    
    if size(tempX,1) < 1
        dat = prdataset(X(1:10,:),y(1:10,:));
        dat = dat([],:);
    else
        dat = prdataset(tempX,tempy);
    end
    
end