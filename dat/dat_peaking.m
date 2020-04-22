function dat = dat_peaking(d, Nc)
    % get Nc samples per class in d dim.
    % so in total we get Nc*2 samples

    m1 = zeros(1,d);
    m2 = zeros(1,d);

    m2(1) = 3;
    m2(2) = 3;

    V = ones(1,d);
    V(1) = sqrt(4);
    V(2) = sqrt(4);

    c1 = randn(Nc, d).*repmat(V,Nc,1) + m1;
    c2 = randn(Nc, d).*repmat(V,Nc,1) + m2;

    dat = prdataset([c1;c2],[ones(Nc,1);-ones(Nc,1)]);
    dat = set(dat,'PRIOR',[0.5 0.5]);
    
    P = randperm(size(dat,1));
    dat = dat(P,:);

end