function ge = global_efficiency( A, type )
% GLOBAL_EFFICIENCY global efficiency of nodes
%
% GE = GLOBAL_EFFICIENCY(A,type) calculates the global efficiency GE
%   for all nodes in the graph represented by the adjacency matrix A.
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
% Date: 2019/02/07
% http://braph.org/

gein = global_efficiency_in(A,type);
geout = global_efficiency_out(A,type);

ge = mean([gein; geout],1);

end