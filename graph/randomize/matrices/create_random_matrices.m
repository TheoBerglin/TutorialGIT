clear all, clc, close all
densities = [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7];

%% Settings
nodes = 1000;
s = nodes*nodes;
type = Graph.WU;
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