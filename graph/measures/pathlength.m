function pl = pathlength( A, type )
% PATHLENGTH path length of nodes
%
% PL = PATH_LENGTH(A,type) calculates the pathlength PL of
%   all nodes in the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The pathlength of a node is the average of the in-pathlength and
% out-pathlength of that node. The path length of disconnected nodes is set
% to NaN. 
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/05
% http://braph.org/

plin = pathlength_in(A, type);
plout = pathlength_out(A, type);

pl = mean([plin; plout],1);

end

