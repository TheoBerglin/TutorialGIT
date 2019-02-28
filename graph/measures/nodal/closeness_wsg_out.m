function cloout = closeness_wsg_out( A, type )
% CLOSENESS_WSG_OUT out-closeness centrality of nodes within subgraphs
%
% CLOOUT = CLOSENESS_WSG_OUT(A,type) calculates the out-closeness 
%   centrality within subgraphs CLOOUT of all nodes in the graph 
%   represented by the adjacency matrix A.
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
% Date: 2019/02/28
% http://braph.org/

plout = pathlength_wsg_out(A,type);
cloout = plout.^-1;

end

