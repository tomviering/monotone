function do_exp(fn_settings)

    % do_exp is run with matlab path pointing at exp folder
    
    addpath('../');
    addpath(genpath('../prtools'));
    addpath('../prtools');
    addpath('../learners');
    addpath('../dat');
    
    warning('off','MATLAB:nchoosek:LargeCoefficient');

    settings = load(['../res/',fn_settings]);
    fn_res = settings.res_fn;
    [settings, res] = make_learning_curve(settings);
    
    res.settings = settings;
    
    save(fn_res,'-struct','res');
    fprintf('experiment done. saved results to %s',fn_res);
    
end