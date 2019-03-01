function cplin_wsg = characteristic_pathlength_wsg_in( A, type)
% CHARACTERISTIC_PATHLENGTH_WSG_IN characteristic in-pathlength within subgraphs of graph
%
% CPLIN_WSG = CHARACTERISTIC_PATHLENGTH_WSG_IN(A,type) calculates 
%   characteristic in-pathlength CPLIN_WSG within subgraphs of the graph 
%   represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The in-pathlength-wsg is the average shortest pathlength from all other
%   nodes to a particular node. Only nodes belonging to the same subgraph
%   are taken into consideration. The in-pathlength-wsg of disconnected 
%   nodes is set to NaN.
%
% The characteristic in-pathlength within subgraphs is the average of the
% in-pathlength within subgraphs
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

cplin_wsg = mean(pathlength_wsg_in(A, type));
