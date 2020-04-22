function h = addtoplotsingle(r, ind, leg, rep, count_val, S)
    h = {};
    if (nargin < 5)
        count_val = 1;
    end
    if (nargin < 6)
        S = '-';
    end
    
    for i = ind
        if count_val
            X = mean(r.xval2(:,i,rep),3);
        else
            X = mean(r.xval(:,i,rep),3);
        end
        Y = mean(r.error(:,i,rep),3);
        leg_final = [r.leg{i} ' ' leg];
        hold on;
        h{end+1} = plot(X,Y,S,'DisplayName',leg_final);
    end 
    legend show;

end

