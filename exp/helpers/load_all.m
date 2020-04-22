function [settings, r] = load_all(settings_obj,skip_keep_info)

    if (nargin < 2)
        skip_keep_info = 1;
    end
    
    if (~isfield(settings_obj,'parts'))
        warning('no parts found, assuming its just the filename...');
        r = load(settings_obj);
        settings = [];
        return;
    end

    parts = settings_obj.parts;
    
    
    settings = load(settings_obj.fns{1});
    res_fn = settings.res_fn;
    
    if (skip_keep_info == 1)
        except = 'info_keep';
        res = load(res_fn,'-regexp', ['^(?!' except ')\w']);
        res.info_keep = cell(0,0,0);
    else
        res = load(res_fn);
    end
    
    error = res.error(:,:,[]);
    xval = res.xval(:,:,[]);
    xval2 = res.xval(:,:,[]);
    reptime = res.reptime(:,[]);
    non_monotone = res.non_monotone(:,:,[]);
    info_keep = cell(size(res.info_keep,1),size(res.info_keep,2),0);
    leg = {};
    
    for i = 1:parts
        fprintf('loading %d of %d...\n',i,parts);
        settings = load(settings_obj.fns{i});
        res_fn = settings.res_fn;
        
        if (skip_keep_info == 1)
            except = 'info_keep';
            res = load(res_fn,'-regexp', ['^(?!' except ')\w']);
            res.info_keep = cell(0,0,0);
        else
            res = load(res_fn);
        end
        
        leg = res.leg;
        
        error = cat(3,res.error,error);
        xval = cat(3,res.xval,xval);
        xval2 = cat(3,res.xval2,xval2);
        reptime = cat(2,res.reptime,reptime);
        non_monotone = cat(3,res.non_monotone,non_monotone);
        info_keep = cat(3,res.info_keep,info_keep);
    end
    
    r.error = error;
    r.xval = xval;
    r.xval2 = xval2;
    r.reptime = reptime;
    r.non_monotone = non_monotone;
    r.info_keep = info_keep;
    r.leg = leg;

end