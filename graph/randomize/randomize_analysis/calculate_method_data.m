clear all, clc, close all;
%% Settings
methods = {};
graph_types = {};
nodes = [];
densities = [];
rerun_existing = true;

%% Loops

for mi = 1:length(methods)
    % load method save if it exist
    method = methods{mi};
    for gi = 1:length(graph_types)
        type = graph_types{gi};
        dir = Graph.is_directed(type);
        wei = Graph.is_weighted(type);
        for ni = 1:length(nodes)
            n = nodes(ni);
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