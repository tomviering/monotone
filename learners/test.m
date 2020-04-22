function p = test(p1, p2, y, mcnemar)
% p1: predictions of model 1 (current)
% p2: predictions of model 2 (best)
% y: true labeling
    if (nargin < 4)
        mcnemar = false;
    end

    e1 = (p1 ~= y);
    e2 = (p2 ~= y);
    
    a = sum(and(e1 == 0, e2 == 0));
    b = sum(and(e1 == 0, e2 == 1));
    c = sum(and(e1 == 1, e2 == 0));
    d = sum(and(e1 == 1, e2 == 1));
    
    if (mcnemar)
        p = test_chi_squared(b, c);
    else
        p = test_exact_binomial(b,c);
    end

end