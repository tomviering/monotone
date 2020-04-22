function curstr = fix_str(curstr)

          
        %curstr = h.String{i};
        
        curstr = strrep(curstr,'optimal regularization crossval fast','$\lambda_{CV}$ ');
        curstr = strrep(curstr,'optimal regularization add val','$\lambda_{S}$ ');
        
        curstr = strrep(curstr,'normal learner (ignores Nv)','standard learner');
        curstr = strrep(curstr,'normal learner','standard learner');
        curstr = strrep(curstr,'monotone binomial test ','$M_{HT}$ ');
        curstr = strrep(curstr,'monotone simple ','$M_{S}$ ');
        curstr = strrep(curstr,'monotone simple','$M_{S}$ ');
        curstr = strrep(curstr,'crossval fast','$M_{CV}$ ');
        
        curstr = strrep(curstr,'add val','');
        %monotone simple 
        
    
end