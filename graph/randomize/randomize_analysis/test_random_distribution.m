%% Settings
clear all, clc, close all
multiple_originals = true;
load_matrix = struct('load', false, 'type', Graph.BD, 'density', 0.2, 'nodes', 50, 'give_name', false);
n_runs = 10000;
method = 'randmio_dir_signed_edit';
give_name = true;
%% Select first matrix
A_org = [0 0 1 0;1 0 0 1;1 0 0 1;0 1 0 0];
if load_matrix.load
    give_name = load_matrix.give_name;
    dir = Graph.is_directed(load_matrix.type);
    wei = Graph.is_weighted(load_matrix.type);
    %% Strings for loading data
    if wei
        type_bin = 'wei';
    else
        type_bin = 'bin';
    end
    if dir
        type_dir = 'dir';
    else
        type_dir = 'undir';
    end
    load_file = sprintf('dens_%s_nodes_%d_%s_%s.txt', num2str(load_matrix.density, '%.3f'), load_matrix.nodes, type_bin, type_dir);  %
    if exist(load_file, 'file')
        A_org = load(load_file);
    else
        fprintf('Did not load matrix dens: %.3f %s %s\n', load_matrix.density, type_bin, type_dir)
    end
end


data(1) = struct('A', A_org, 'count', 0);
full_data(1) = struct('org', A_org, 'distribution', data);
if multiple_originals
    for i = 1:10000
        n_matrices = length(full_data);
        eval(sprintf('rA = %s(A_org);', method));
        found = false;
        for ci = 1:n_matrices
            if all(all(full_data(ci).org == rA))
                found = true;
            end
        end
        if ~found
            full_data(n_matrices+1) = struct('org', rA, 'distribution', data);
        end
    end
    fprintf('Found %d possible original matrices\n', length(full_data));
end

for org_i = 1:length(full_data)
    fprintf('Running for original matrix %d\n', org_i)
    for i=1:n_runs
        eval(sprintf('rA = %s(full_data(org_i).org);', method));
        n_matrices = length(full_data(org_i).distribution);
        found = false;
        for ci = 1:n_matrices
            if all(all(full_data(org_i).distribution(ci).A == rA))
                full_data(org_i).distribution(ci).count = full_data(org_i).distribution(ci).count + 1;
                found = true;
                break
            end
        end
        if ~found
            full_data(org_i).distribution(n_matrices+1) = struct('A', rA, 'count', 1);
        end
    end
end

%% Give each found matrix a name
names = {'Alpha',...
    'Bravo',...
    'Charlie',...
    'Delta',...
    'Echo',...
    'Foxtrot',...
    'Golf',...
    'Hotel',...
    'India',...
    'Juliet',...
    'Kilo',...
    'Lima',...
    'Mike',...
    'November',...
    'Oscar',...
    'Papa',...
    'Quebec',...
    'Romeo',...
    'Sierra',...
    'Tango',...
    'Uniform',...
    'Victor',...
    'Whiskey',...
    'X-ray',...
    'Yankee',...
    'Zulu'};
if give_name
    disp('Giving names')
    mats = {};
    for fi = 1:length(full_data)
        for di = 1:length(full_data(fi).distribution)
            found = false;
            for mi = 1:length(mats)
                if all(all(mats{mi}==full_data(fi).distribution(di).A))
                    found = true;
                    break
                end
            end
            if ~found
                mats{end+1} = full_data(fi).distribution(di).A;
            end
        end
    end
    if length(mats) <=length(names)
        for fi = 1:length(full_data)
            for mi = 1:length(mats)
                if all(all(mats{mi}==full_data(fi).org))
                    full_data(fi).name = names{mi};
                    break
                end
            end
            for di = 1:length(full_data(fi).distribution)
                
                for mi = 1:length(mats)
                    if all(all(mats{mi}==full_data(fi).distribution(di).A))
                        full_data(fi).distribution(di).name = names{mi};
                        break
                    end
                end
                
            end
        end
    else
        disp('can not give names, to many unique matrices')
    end
    
end
