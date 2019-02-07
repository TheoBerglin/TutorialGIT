function cloout = closeness_out( A, type )
% CLOSENESS_OUT out-closeness centrality of nodes
%
% CLOOUT = CLOSENESS_OUT(A,type) calculates the out-closeness centrality
%   CLOOUT of all nodes in the graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-closeness centrality is the inverse of the out-path lengths, i.e.
%   the inverse of the average shortest path from a particular node to all 
%   other nodes to one.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/06
% http://braph.org/

plout = pathlength_out(A,type);
cloout = plout.^-1;

end

