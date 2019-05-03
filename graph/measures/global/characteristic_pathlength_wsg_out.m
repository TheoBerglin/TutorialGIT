function cplout_wsg = characteristic_pathlength_wsg_out( A, type)
% CHARACTERISTIC_PATHLENGTH_WSG_OUT characteristic out-path length within subgraphs of graph
%
% CPLOUT_WSG = CHARACTERISTIC_PATHLENGTH_WSG_OUT(A,type) calculates the 
%   characteristic out-pathlength CPLOUT_WSG within subgraphs of the graph 
%   represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-pathlength-wsg is the average shortest path length from a particular
%   node to all other nodes. Only nodes belonging to the same subgraph
%   are taken into consideration. The out-pathlength-wsg of
%   disconnected nodes is set to NaN.
%
% The characteristic out-pathlength within subgraphs is the average of the
% out-pathlength within subgraphs
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/
pl_wsg_out = pathlength_wsg_out(A, type);
cplout_wsg = mean(pl_wsg_out(~isnan(pl_wsg_out)));
