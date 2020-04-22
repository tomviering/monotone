function listlearners(r)

    for i = 1:length(r.leg)
        fprintf('%d: %s \n',i,r.leg{i});
    end

end