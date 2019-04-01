function cpl_wsg = characteristic_pathlength_wsg( A, type)
% CHARACTERISTIC_PATHLENGTH_WSG characteristic path length within subgraphs of graph
%
% CPL_WSG = CHARACTERISTIC_PATHLENGTH_WSG(A,type) calculates the 
%   characteristic pathlength CPL_WSG within subgraphs of the graph
%   represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The pathlength-wsg of a node is the average of the in-pathlength-wsg and
%   out-pathlength-wsg of that node. The pathlength-wsg of disconnected 
%   nodes is set to NaN. 
%
% The characteristic pathlength within subgraphs is the average of the
% pathlength within subgraphs
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

pl_wsg = pathlength_wsg(A, type);
cpl_wsg = mean(pl_wsg(~isnan(pl_wsg)));
