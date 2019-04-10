clear all, clc, close all;
%% Settings
methods = {'randmio_dir_signed_edit'};
graph_types = {Graph.BD};
nodes = [50];
densities = [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7];
rerun_existing = true;
n_randomizations = 500;
desc_str = sprintf('%s', datestr(datetime('now')));
load_matrix = true;
%% Create data path for saving
current_loc = fileparts(which('calculate_method_data.m'));
data_path = path_append(current_loc, 'data');
exist_create_dir(data_path);
addpath(data_path);
%% Default structures
rand_structure = struct('density', nan, 'weighted', false, 'directed', false, ...
    'measures', struct(), 'desc', 'TEMP', 'p_value_self', struct(), 'compare_measures', struct(),...
    'p_value_vs_gt', struct(), 'p_value_gt', struct());
node_structure = struct('nodes', 10, 'node_data', rand_structure);

%% Loops
for mi = 1:length(methods)
    % load method save if it exist
    method = methods{mi};
    data_name = sprintf('data_%s.mat', method);
    fprintf('Running for method: %s\n', method)
    if exist(data_name, 'file')
        d = load(data_name);
        data = d.data;
        clear d
        
    else
        data = node_structure;
    end
    gi = mi; % Graph type index
    for ni = 1:length(nodes)
        n = nodes(ni);
        data_r = find(extractfield(data, 'nodes') == n);
        fprintf('Running for node size: %d\n', n);
        if isempty(data_r)
            % create data row
            data(end+1) = struct('nodes', n, 'node_data', rand_structure);
            data_r = length(data);
        end
        
        type = graph_types{gi};
        dir = Graph.is_directed(type);
        wei = Graph.is_weighted(type);
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
        fprintf('Graph type: %s %s\n',type_bin, type_dir)
        
        for di = 1:length(densities)
            dens = densities(di);
            rowi = node_data_row(data(data_r).node_data, dens, type);
            tic
            if rowi <= length(data(data_r).node_data)
                % This measure already exist
                if ~rerun_existing
                    % If we don't want to rerun existing, continue with
                    % next
                    continue
                end
            end
            %% Load matrix data
            if load_matrix
                load_file = sprintf('dens_%s_nodes_%d_%s_%s.txt', num2str(dens, '%.3f'), n, type_bin, type_dir);  %
                if exist(load_file, 'file')
                    A = load(load_file);
                else
                    fprintf('Did not load matrix dens: %.3f %s %s\n', dens, type_bin, type_dir)
                   
                    A = create_matrix(dens, n, dir, wei);
                end
            else
                A = create_matrix(dens, n, dir, wei);
            end
            
            %% run randomization
            % run randomization
            [gm_struct1, gm_struct2] = run_randomization(A, type, method, n_randomizations);
            % add data
            data(data_r).node_data(rowi) = rand_structure; % initialize the structure
            % Add information
            data(data_r).node_data(rowi).density = dens;
            data(data_r).node_data(rowi).weighted = wei;
            data(data_r).node_data(rowi).directed = dir;
            data(data_r).node_data(rowi).measures = gm_struct1;
            p_value_struct = calculate_pvalue_struct(gm_struct1, gm_struct2);
            data(data_r).node_data(rowi).p_value_self = p_value_struct;
            data(data_r).node_data(rowi).compare_measures = gm_struct2;
            data(data_r).node_data(rowi).desc = desc_str;
            fprintf('Done with density %.3f in time %.3fs\n', dens, toc)
            % save data
            data_save_name = path_append(data_path, data_name);
            save(data_save_name, 'data');
        end
    end
    fprintf('Done with method: %s\n', method)
    disp('---------------------------------')
end
disp('Done with all')