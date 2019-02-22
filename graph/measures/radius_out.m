function rout = radius_out(A, type)
% RADIUS_OUT out-radius of a graph
%
% ROUT = RADIUS_OUT(A, TYPE) calculates the out-radius ROUT of the graph
%   represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-radius of a graph is the minimum out-eccentricity of its nodes.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/13
% http://braph.org/

rout = min(eccentricity_out(A,type));

end