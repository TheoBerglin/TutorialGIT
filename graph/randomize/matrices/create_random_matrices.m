clear all, clc, close all
%% Settings
dens = 0.15; % Between 0 and 1.
nodes = 100;
s = nodes*nodes;
type = Graph.BU;
directed = Graph.is_directed(type);
binary = Graph.is_binary(type);
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
save_file = sprintf('%s%s%s', current_loc, filesep, file_name);
save(save_file, 'A','-ascii', '-double', '-tabs')
