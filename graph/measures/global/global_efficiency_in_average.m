function res = global_efficiency_in_average( A, type)
% GLOBAL_EFFICIENCY_IN_AVERAGE average of the in-global efficiency for each node
%
% RES = GLOBAL_EFFICIENCY_IN_AVERAGE(A,type) calculates the average of 
%   the in-global efficiency for all nodes in the graph represented by 
%   the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The in-global efficiency of a node is the average of the inverse
%   inward shortest path length, and is inversely related to
%   the in-path length of the node.
%
% In these calculations, the diagonal of connection matrix is removed i.e.
%   self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

res = mean(global_efficiency_in(A, type));
