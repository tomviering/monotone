function dat = dat_dipping(Nc)

    d = 1;

    m1 = 0;
    
    m2 = -5;
    m3 = 5;
    
    count = Nc/2;
    
    X1 = randn(count*2,d) + m1;
    
    myswitch = rand(Nc,1);
    mytrue = myswitch > 0.5;
    
    m23(mytrue == 1) = m2;
    m23(mytrue == 0) = m3;
    
    X23 = randn(count*2,d) + m23';
    
    %X2 = randn(count,d) + m2;
    %X3 = randn(count,d) + m3;
    
    dat = prdataset([X1;X23],[ones(count*2,1);-ones(count*2,1)]);
    dat = set(dat,'PRIOR',[0.5 0.5]);
    P = randperm(size(dat,1));
    dat = dat(P,:);

end