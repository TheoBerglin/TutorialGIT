clear all, clc, close all

densities = [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.15 0.2 0.3 0.4 0.5 0.6 0.7];
%% Settings
nodes = 10;
s = nodes*nodes;
possible_connections = nodes*(nodes-1);
type = Graph.WU;
directed = Graph.is_directed(type);
binary = Graph.is_binary(type);

for i=1:length(densities)
    dens = densities(i); % Between 0 and 1.

    %% Generate matrix
    A = zeros(nodes, nodes);
    
    if directed
        % generate edges as long as desired density is not met
        while numel(find(A)) ~= round(possible_connections*dens)
            new_edges = round(possible_connections*dens) - numel(find(A));
            indices = randperm(s, new_edges);
            A(indices) = 1;
            A = remove_diagonal(A);
        end
    else % undirected
        % generate edges as long as (half of the) desired density is not met
        while numel(find(A)) ~= round(possible_connections*dens/2)
            new_edges = round(possible_connections*dens/2) - numel(find(A));
            indices = randperm(s, new_edges);
            if ~isempty(indices)
                [row, col] = ind2sub(size(A), indices);
                indices_to_keep = col>row;  % fill upper triangle
                A(indices(indices_to_keep)) = 1;
                A = remove_diagonal(A);
            end
        end
    end

    %% Binary/weight settings
    if binary
        str_bin = 'bin';
    else
        % Add weights
        str_bin = 'wei';
        W = rand(nodes);
        A = A.*W;
    end
    
    %% Directed/undirected settings
    if directed 
        str_dir = 'dir';
    else
        str_dir = 'undir';
        A = A+A.';  % symmetrize
    end
        
    %% Save matrix
    dA =  density(A, type)/100;
    fprintf('Created matrix of density: %.4f\n',dA);
    current_loc = fileparts(which('create_random_matrices.m'));
    file_name = sprintf('dens_%.3f_nodes_%d_%s_%s.txt', dens, nodes, str_bin, str_dir);
    save_file = sprintf('%s%snodes_%d%s%s', current_loc, filesep, nodes, filesep, file_name);
    save(save_file, 'A','-ascii', '-double', '-tabs')
end
