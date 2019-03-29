clear all, clc, close all;
%% Settings
methods = {'randomize_combo_WU_fix'};
graph_types = {Graph.WU};
nodes = [10];
densities = [0.01 0.02 0.2];
rerun_existing = true;
n_randomizations = 10;
desc_str = sprintf('%s', datestr(datetime('now')));
load_matrix = true;
%% Create data path for saving
current_loc = fileparts(which('calculate_method_data.m'));
data_path = path_append(current_loc, 'data');
exist_create_dir(data_path);
addpath(data_path);
%% Default structures
rand_structure = struct('density', nan, 'weighted', false, 'directed', false, ...
    'measures', struct(), 'desc', 'optional');
node_structure = struct('nodes', 10, 'node_data', struct());

%% Loops
for mi = 1:length(methods)
    % load method save if it exist
    method = methods{mi};
    data_name = sprintf('data_%s.mat', method);
    if exist(data_name, 'file')
        d = load(data_name);
        data = d.data;
        clear d
        
    else
        data = node_structure;
    end
    
    for ni = 1:length(nodes)
        n = nodes(ni);
        data_r = find(extractfield(data, 'nodes') == n);
        if isempty(data_r)
            % create data row
            data(end+1) = struct('nodes', n, 'node_data', struct());
            data_r = length(data);
        end
        
        for gi = 1:length(graph_types)
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
            for di = 1:length(densities)
                dens = densities(di);
                rowi = node_data_row(data(data_r).node_data, dens, type);
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
                        A = create_matrix(dens, n, dir, wei);
                    end
                else
                    A = create_matrix(dens, n, dir, wei);
                end
                
                %% run randomization
                % run randomization
                gm_struct = run_randomization(A, type, method, n_randomizations);
                % add data
                data(data_r).node_data(rowi) = rand_structure; % initialize the structure
                % Add information
                data(data_r).node_data(rowi).density = dens;
                data(data_r).node_data(rowi).weighted = wei;
                data(data_r).node_data(rowi).directed = dir;
                data(data_r).node_data(rowi).measures = gm_struct;
                data(data_r).node_data(rowi).desc = desc_str;
                
            end
        end
    end
    % save data
    save(data_name, 'data');
end