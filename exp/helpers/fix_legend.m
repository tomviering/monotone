function fix_legend()

    h = legend;
    n = length(h.String);
    h.Interpreter = 'latex';
    
    for i = 1:n
        
        curstr = h.String{i};
        
        curstr = strrep(curstr,'optimal regularization crossval fast','$\lambda_{CV}$ ');
        curstr = strrep(curstr,'optimal regularization add val','$\lambda_{S}$ ');
        
        curstr = strrep(curstr,'normal learner (ignores Nv)','standard learner');
        curstr = strrep(curstr,'normal learner','standard learner');
        curstr = strrep(curstr,'monotone binomial test ','$MT_{HT}$ ');
        curstr = strrep(curstr,'monotone simple ','$MT_{S}$ ');
        curstr = strrep(curstr,'monotone simple','$MT_{S}$ ');
        curstr = strrep(curstr,'crossval fast','$MT_{CV}$ ');
        
        curstr = strrep(curstr,'add val','');
        %monotone simple 
        
        h.String{i} = curstr;
    end

end