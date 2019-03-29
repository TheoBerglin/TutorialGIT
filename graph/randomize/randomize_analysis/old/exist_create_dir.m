function exist_create_dir( d )
%EXIST_CREATE_DIR 

if ~exist(d, 'dir')
    mkdir(d)
end

end

