function cloin = closeness_in( A, type )
% CLOSENESS_IN in-closeness centrality of nodes
%
% CLOIN = CLOSENESS_IN(A,type) calculates the in-closeness centrality
%   CLOIN of all nodes in the graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The in-closeness centrality is the inverse of the in-path lengths, i.e.
%   the inverse of the average shortest path from all nodes to one
%   particular node.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/06
% http://braph.org/

plin = pathlength_in(A,type);
cloin = plin.^-1;

end

