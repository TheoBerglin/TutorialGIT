clear all, clc, close all;
%% Settings
methods = {};
graph_types = {};
nodes = [];
densities = [];
rerun_existing = true;

%% Create data path for saving
current_loc = fileparts(which('calculate_method_data.m'));
data_path = path_append(current_loc, 'data');
exist_create_dir(data_path);
addpath(data_path);
%% Default structures
rand_structure = struct('density', nan, 'weighted', false, 'directed', false, ...
    'measures', struct());
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
        end
        
        for gi = 1:length(graph_types)
            type = graph_types{gi};
            dir = Graph.is_directed(type);
            wei = Graph.is_weighted(type);
            for di = 1:length(densities)
                dens = densities(di);
                %if measure exist
                % if ~rerun existing
                %        continue;
                % if matrix_exist
                %   load matrix
                % else
                % create matrix
                % run randomization
                % add data
            end
        end
    end
    % save data
end