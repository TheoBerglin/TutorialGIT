function res = local_efficiency_average( A, type)
% LOCAL_EFFICIENCY_AVERAGE_NODAL average of the local efficiency of each node
%
% RES = LOCAL_EFFICIENCY_AVERAGE_NODAL(A,TYPE) calculates the average of 
%   the local efficiency of each node in the graph represented by the 
%   adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The local efficiency of a node is the global efficiency calculated
%   on the subgraph created by the neighbours of the node and is related
%   to the clustering coefficient.  That is the local efficiency of a node i
%   characterizes how well information is exchanged by its neighbors when it is removed.
%
% In these calculations, the diagonal of connection matrix is removed i.e.
%   self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

res = mean(local_efficiency(A, type));
