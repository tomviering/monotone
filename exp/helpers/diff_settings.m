function different = diff_settings(s1,s2)

    f = fieldnames(s1);
    
    for i = 1:length(f)
        field_name = f{i};
        
        v1 = s1.(field_name);
        v2 = s2.(field_name);
        
        if (field_name == 'c')
            v1 = v1.name;
            v2 = v2.name;
        end
        
        if ~isequal(v1,v2) 
            fprintf('value in settings 1:');
            v1
            fprintf('value in settings 2:');
            v2
            
            different = 1;
            return;
        end
    end
    
    different = 0;
    return;
end