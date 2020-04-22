% removes all info_keep from all result files in the current dir

file_list = dir()

for i = 3:length(file_list)
    
    res_fn = file_list(i).name;

    except = 'info_keep';
    res = load(res_fn,'-regexp', ['^(?!' except ')\w']);
    res.info_keep = cell(0,0,0);
    
    save(res_fn,'-struct','res')

end

