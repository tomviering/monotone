function addtoplotE(r, ind, leg, count_val, S)
    if (nargin < 4)
        count_val = 1;
    end
    if (nargin < 5)
        S = '-';
    end
    
    for i = ind
        if count_val
            X = mean(r.xval2(:,i,:),3);
        else
            X = mean(r.xval(:,i,:),3);
        end
        Y = mean(r.error(:,i,:),3);
        Ystd = std(r.error(:,i,:),0,3)/sqrt(size(r.error,3))*1.96;
        leg_final = [r.leg{i} ' ' leg];
        hold on;
        %plot(X,Y,S,'DisplayName',leg_final);
        errorbar(X,Y,Ystd,S,'DisplayName',leg_final);
    end 
    legend show;

end

