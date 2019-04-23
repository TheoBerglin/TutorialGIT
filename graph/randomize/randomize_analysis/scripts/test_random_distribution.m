%% Settings
clear all, clc, close all
multiple_originals = true;
load_matrix = struct('load', false, 'type', Graph.BU, 'density', 0.003, 'nodes', 50, 'give_name', false);
n_runs = 100000;
methods ={'randomize_braph_BU'};%{'randomize_braph_BD' 'randomize_braph_BD_no_mw' 'randomize_bct_D' };% 'randomize_braph_BU_bias_fix'}; %{'randomize_braph_BD' 'randmio_dir_signed_edit_low_attempts' 'randomize_bct_D_low_attempts' 'randomize_bct_D_high_attempts' 'randmio_dir_signed_edit_high_attempts'...
    %'randomize_bct_D' 'randmio_dir_signed_edit'};
give_name = multiple_originals;
%% Select first matrix
A_org = [0 0 1 0;1 0 0 1;1 0 0 1;0 1 0 0]; % Directed
% Directed aswell, density 5.5
A_org_10 = [0 0 0 0 0 0 0 1 0 0;0 0 0 0 0 0 0 0 0 0;0 1 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 1 0;0 0 0 0 0 0 0 0 0 0;1 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0 0;0 0 0 0 1 0 0 0 0 0];
% Directed density 14.5, not valid. Self connections
A_org_10 = [0 1 0 0 0 0 0 0 0 0;0 0 0 0 1 1 0 0 0 0;0 0 0 0 0 0 0 0 0 1;1 0 0 0 1 0 0 0 0 0;0 0 0 0 0 1 0 0 0 0;0 0 0 0 0 0 0 0 0 0;0 1 0 1 0 0 0 0 0 0;0 0 0 1 0 1 0 1 1 0;0 0 0 0 0 0 0 0 0 0;0 1 0 0 0 0 0 0 0 0];
%A_org_7 = [0 0 0 0 0 1 0;0 0 0 1 0 0 1;0 0 0 1 1 0 0;0 1 1 0 0 0 0;0 0 1 0 0 0 0;1 0 0 0 0 0 0;0 1 0 0 0 0 0];
%A_org = A_org_7;
% 15 density
A_org_7 = [0 0 1 1 0 0 0;0 0 0 0 0 0 0;0 0 0 1 0 0 0;0 0 0 0 0 0 1;0 0 0 0 0 0 1;0 0 0 0 0 0 0;0 0 1 0 0 0 0];
% 35 density fully connected
A_org_7 = [0 0 1 0 0 1 1;0 0 1 0 0 0 1;0 1 0 0 1 0 0;0 1 0 0 1 0 0;0 0 0 1 0 1 1;1 0 0 0 0 0 0;0 0 1 0 1 0 0];
%A_org = [0 0 1 0 1;0 0 0 1 0;1 0 0 0 0;0 1 0 0 1;1 0 0 1 0];
%A_org = [0 1 0 0;1 0 0 0;0 0 0 1;0 0 1 0];
A_org = A_org_7;
A_org = [0 1 0 0;1 0 0 0;0 0 0 0;0 0 0 0];
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
    if exist(load_file, 'file') && 1 == 2
        A_org = load(load_file);
    else
        A_org = create_matrix(load_matrix.density*100,  load_matrix.nodes, dir, wei);
        fprintf('Did not load matrix dens: %.3f %s %s\n', load_matrix.density, type_bin, type_dir)
        fprintf('Created matrix with number of edges: %d\n', sum(sum(A_org)));
    end
end
n = size(A_org,1);
names = {'Alpha', 'Bravo','Charlie', 'Delta','Echo','Foxtrot',...
    'Golf','Hotel','India','Juliet','Kilo','Lima','Mike','November',...
    'Oscar','Papa','Quebec','Romeo','Sierra','Tango',...
    'Uniform','Victor','Whiskey','X-ray','Yankee','Zulu'};
data(1) = struct('A', A_org, 'count', 0, 'name', names{1});
full_data(1) = struct('org', A_org, 'distribution', data);
if multiple_originals
    for i = 1:10000
        n_matrices = length(full_data);
        eval(sprintf('rA = %s(A_org);', methods{1}));
        found = false;
        for ci = 1:n_matrices
            if all(all(full_data(ci).org == rA))
                found = true;
            end
        end
        if ~found
            full_data(n_matrices+1) = struct('org', rA, 'distribution', struct('A', rA, 'count', 0, 'name', names{1}));
        end
    end
    fprintf('Found %d possible original matrices\n', length(full_data));
    
    if give_name
        disp('Giving names')
        mats = {A_org};
        for fi = 1:length(full_data)
            found = false;
            for mi = 1:length(mats)
                if all(all(mats{mi}==full_data(fi).org))
                    found = true;
                    break
                end
            end
            if ~found
                mats{end+1} = full_data(fi).org;
            end
        end
        if length(mats) <=length(names)
            for fi = 1:length(full_data)
                for mi = 1:length(mats)
                    if all(all(mats{mi}==full_data(fi).org))
                        full_data(fi).name = names{mi};
                        full_data(fi).distribution(1).name = names{mi};
                        break
                    end
                end
            end
        else
            disp('can not give names, to many unique matrices')
        end
    end
end
%% Save file
current_loc = fileparts(which('calculate_method_data.m'));
file_name = 'distribution_data';
if exist(file_name, 'file')
    d = load(file_name);
    dist_data = d.dist_data;
    clear d
else
    dist_data = struct();
end
node_field = sprintf('node_%d', n);
if ~isfield(dist_data, node_field)
    dist_data.(node_field) = struct();
end

full_data_org = full_data; % Keep original unfilled
for meth = 1:length(methods)
    full_data = full_data_org; % Reset
    method = methods{meth};
    fprintf('Running for method: %s\n', method)
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
                name = 'unknown';
                if give_name
                    for mi = 1:length(mats)
                        if all(all(mats{mi}== rA))
                            name = names{mi};
                            break
                        end
                    end
                end
                full_data(org_i).distribution(n_matrices+1) = struct('A', rA, 'count', 1, 'name', name);
            end
        end
    end
     dist_data.(node_field).(method) = full_data;
end
save(file_name, 'dist_data');