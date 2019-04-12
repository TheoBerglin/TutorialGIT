clear all, clc, close all;
%% Settings
methods = {'randomize_braph_BU_bias_fix'};
graph_types = {Graph.BU};
nodes = [50];
densities = [0.01 0.015 0.02 0.025 0.03 0.035 0.04 0.045 0.05 0.055 0.06 0.065 0.07 0.075 0.08 0.085...
    0.09 0.095 0.1 0.105 0.150 0.2 0.3 0.4 0.5 0.6 0.7];
n_randomizations = 500;
desc_str = sprintf('%s', datestr(datetime('now')));
load_matrix = true;
%% Create data path for saving
current_loc = fileparts(which('calculate_method_data.m'));
data_path = path_append(current_loc, 'bias_braph');
exist_create_dir(data_path);
addpath(data_path);
%% Default structures
rand_structure = struct('density', nan, 'weighted', false, 'directed', false, ...
    'desc', 'TEMP', 'miswires', nan, 'random_wires', nan);
node_structure = struct('nodes', 10, 'node_data', rand_structure);

%% Loops
for mi = 1:length(methods)
    method = methods{mi};
    data_name = sprintf('bias_braph_%s.mat', method);

    data = node_structure;
    
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
            miswires_arr = zeros(1, n_randomizations);
            randwires_arr = zeros(1, n_randomizations);
            for ri = 1:n_randomizations
%                 eval(sprintf('[rA, mw] = %s(A);', method));
                eval(sprintf('[rA, mw, rw] = %s(A);', method));
                miswires_arr(ri) = mw;
                randwires_arr(ri) = rw;
            end

            % add data
            data(data_r).node_data(rowi) = rand_structure; % initialize the structure
            % Add information
            data(data_r).node_data(rowi).density = dens;
            data(data_r).node_data(rowi).weighted = wei;
            data(data_r).node_data(rowi).directed = dir;
            data(data_r).node_data(rowi).desc = desc_str;
            data(data_r).node_data(rowi).miswires = miswires_arr;
            data(data_r).node_data(rowi).random_wires = randwires_arr;            
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