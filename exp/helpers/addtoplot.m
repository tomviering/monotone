function h = addtoplot(r, ind, leg, count_val, S)
    % r: result object
    % ind: index of the learner in r
    % leg: add something extra to the legend
    % count_val: whether or not to count validation data on the x-axis
    % S: the linestyle
    
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
        leg_final = [r.leg{i} ' ' leg];
        hold on;
        if strcmp(leg,'noleg')
            h = plot(X,Y,S);
            
        else
            h = plot(X,Y,S,'DisplayName',leg_final);
            legend show;
        end
    end 
    

end

