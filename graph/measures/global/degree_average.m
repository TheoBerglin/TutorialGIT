function res = degree_average( A, type)
% DEGREE_AVERAGE average of the degree of a node
%
% RES = DEGREE_AVERAGE(A, TYPE) calculates the average of the degree 
%   of all nodes in the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The node degree is the number of edges connected to a node with non-zero
% weight.
%
% In these calculations, the diagonal of the connection matrix is removed
% so that self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

res = mean(degree(A, type));
