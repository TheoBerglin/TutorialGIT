function pl = pathlength_wsg( A, type )
% PATHLENGTH_WSG path length of nodes within subgraphs
%
% PL = PATHLENGTH_WSG(A,type) calculates the pathlength PL within subgraphs
%   of all nodes in the graph represented by the connectivity matrix A.
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
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/05
% http://braph.org/

plin = pathlength_wsg_in(A, type);
plout = pathlength_wsg_out(A, type);

pl = mean([plin; plout],1);

end

