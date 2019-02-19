function le = local_efficiency_graph( A, type )
% LE local efficiency of a graph
%
% LE = LOCAL_EFFICIENCY_GRAPH(A,TYPE) calculates the local efficiency LE
%   of the graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The local efficiency of a graph is the average of the local efficiencies
%   of all nodes. The local efficiency of a node is the global efficiency
%   calculated on the subgraph created by the neighbours of the node and
%   is related to the clustering coefficient.
%
% In these calculations, the diagonal of connection matrix is removed i.e.
%   self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/11
% http://braph.org/

le = mean(local_efficiency_nodal(A, type));

end