function res = global_efficiency_average( A, type)
% GLOBAL_EFFICIENCY_AVERAGE average of the global efficiency of nodes
%
% RES = GLOBAL_EFFICIENCY_AVERAGE(A,type) calculates the average of the 
%   global efficiency for all nodes in the graph represented by the 
%   adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The global efficiency of a node is the average of the in-global and
%   out-global efficiency, which in turn is the average inverse inward
%   and outward shortest path lengths.
%
% In these calculations, the diagonal of connection matrix is removed i.e.
%   self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

res = mean(global_efficiency(A, type));
