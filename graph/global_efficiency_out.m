function geout = global_efficiency_out( A, type )
% GLOBAL_EFFICIENCY_OUT OUT-global efficiency for each node
%
% GEOUT = GLOBAL_EFFICIENCY_OUT(A,type) calculates the out-global efficiency GEOUT 
%   for all nodes in the graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-global efficiency of a node is the average of the inverse
%   outward shortest path length, and is inversely related to
%   the out-path length of the node.
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

geout = sum(Di,2)'/(N-1);

end