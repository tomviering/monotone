function [p_matlab, p_old] = test_exact_binomial(b,c)
% computes the probability p that the amount of errors of two models is the
% same. if p < confidence level, we can assume the models differ
% significantly in performance.
% b: amount of samples model 1 got correct, but model 2 got wrong
% c: amount of samples model 2 got correct, but model 1 got wrong

% source: http://rasbt.github.io/mlxtend/user_guide/evaluate/mcnemar/

    n = b+c;
    if (nargout > 1)
        p_old = 0;
        for i = b:n % this includes b, so b or more
            p_old = p_old + nchoosek(n,i)*(0.5^i)*(1-0.5)^(n-i);
        end
    end
    
    % this exactly produces b_old, so must also include b!
    p_matlab = binocdf(b-1,n,0.5,'upper');
    
end