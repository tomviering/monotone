function benchmark_table()

load('e14_settings')
%tmp = load('e18_settings_fixed');
%settings_obj{4} = tmp.settings_obj;
load('e19_settings')
settings_obj{5} = MNIST19_settings;

%% make table
clc;
for dat_id = [1,3,5]
    
    [settings,r] = load_all(settings_obj{dat_id});
    r = filterruns(r,1:100);
    
    rounds = 1:150;
    if (dat_id == 4)||(dat_id == 5)
        rounds = 1:40;
    end
    
    n = size(r.non_monotone(rounds,:,:),1); % number of rounds
    avg_non_monotone = mean(sum(r.non_monotone(rounds,:,:),1),3);
    avg_non_monotone_frac(dat_id,:) = mean(sum(r.non_monotone(rounds,:,:),1)/n,3);
    std_non_monotone_frac(dat_id,:) = std(sum(r.non_monotone(rounds,:,:),1)/n,0,3);
    
    AULC(dat_id,:) = mean(mean(r.error(rounds,:,:),1),3);
    std_AULC(dat_id,:) = std(mean(r.error(rounds,:,:),1),0,3);

end

method_order = [1,4,3,2,5];
clc;
for method = method_order
    
    mname = r.leg{method};
    mname = fix_str(mname);
    
    fprintf('%20s ',mname);
    
    AULC_precision = [3,2,2];
    frac_precision = [2,2,2];
    
    for dat_id = [1,3,5]

        my_AULC = AULC(dat_id,method);
        my_AULC_std = std_AULC(dat_id,method);
        my_frac = avg_non_monotone_frac(dat_id,method);
        my_frac_std = std_non_monotone_frac(dat_id,method);
        if (dat_id == 1)
            fprintf('& \t \\scriptsize\\tt %0.3f (%0.3f) $~$ &\t \\scriptsize\\tt %0.2f (%0.2f) $~~$',my_AULC,my_AULC_std,my_frac,my_frac_std);
        else
            fprintf('& \t \\scriptsize\\tt %0.2f (%0.2f) $~$ &\t \\scriptsize\\tt %0.2f (%0.2f) $~~$',my_AULC,my_AULC_std,my_frac,my_frac_std);
        end

    end
    
    fprintf('\\\\\n');
end