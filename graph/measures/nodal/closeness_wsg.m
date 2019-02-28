function clo = closeness_wsg( A, type )
% CLOSENESS_WSG closeness centrality of nodes within subgraphs
%
% CLO = CLOSENESS_WSG(A,type) calculates the closeness centrality CLO 
%   within subgraphs of all nodes in the graph represented by the 
%   adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The closeness centrality is the inverse of the path lengths, i.e.
%   the inverse of the average shortest path for all nodes.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/28
% http://braph.org/

pl = pathlength_wsg(A,type);
clo = pl.^-1;

end

