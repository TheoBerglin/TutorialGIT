function gein = global_efficiency_in( A, type )
% GLOBAL_EFFICIENCY_IN in-global efficiency for each node
%
% GEIN = GLOBAL_EFFICIENCY_IN(A,type) calculates the in-global efficiency GEIN for
%   all nodes in the graph represented by the adjacency matrix A.
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
% Date: 2019/02/06
% http://braph.org/

D = distance(A,type);
N = size(A,1);  % nbr of nodes
Di = D.^-1;  % inverse distance
Di = remove_diagonal(Di);  % removes infinite values on diagonal

gein = sum(Di,1)/(N-1);

end