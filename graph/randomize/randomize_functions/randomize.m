function rA = randomize(A, type)
% RANDOMIZE randomizes a matrix
%
% rA = RANDOMIZE( A, type ) randomizes the matrix A while preserving the 
%   in-and out-degree.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%   
% This method performs the randomization in two steps. First it rewires the
%   graph and then, in case of a weighted graph, it reweighs it.
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/03/25
% http://braph.org/

A = remove_diagonal(A);
Ac = sign(A); %Connections only
if Graph.is_directed(type)
    % Rewire the connections
    rA = randomize_braph_BD(Ac);
    %Distribute weights if not binary
    if Graph.is_weighted(type)
        rA = distribute_weights_directed(A, rA);
    end
else
    % Rewire the connections
    rA = randomize_braph_BU(Ac);
    %Distribute weights if not binary
    if Graph.is_weighted(type)
        rA = distribute_weights_undirected(A, rA);
    end
end
end

