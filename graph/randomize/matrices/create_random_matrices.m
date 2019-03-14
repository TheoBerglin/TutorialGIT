clear all, clc, close all

densities = [0.01 0.02 0.03 0.04 0.06 0.07 0.08 0.09];
%% Settings
nodes = 100;
s = nodes*nodes;
type = Graph.BD;
directed = Graph.is_directed(type);
binary = Graph.is_binary(type);

for i=1:length(densities)
    dens = densities(i); % Between 0 and 1.
    %dens = dens+0.01; % To account for diagonal
    %% Generate matrix
    indizes = randperm(s, round(s*dens));
    A = zeros(nodes, nodes);
    A(indizes) = 1;
    
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
        %Symmetrize if undirected
        str_dir = 'undir';
        A = triu(A);
        A = A+A.';
    end
    A = replace_diagonal(A, 1);
    dA =  density(A, type)/100;
    fprintf('Created matrix of density: %.4f\n',dA);
    %% Save matrix
    current_loc = fileparts(which('create_random_matrices.m'));
    file_name = sprintf('dens_%.3f_nodes_%d_%s_%s.txt', dens, nodes, str_bin, str_dir);
    save_file = sprintf('%s%snodes_%d%s%s', current_loc, filesep, nodes, filesep, file_name);
    save(save_file, 'A','-ascii', '-double', '-tabs')
end
