function rin = radius_in(A, type)
% RADIUS_IN in-radius of a graph
%
% RIN = RADIUS_IN(A, TYPE) calculates the in-radius RIN of the graph
%   represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The in-radius of a graph is the minimum in-eccentricity of its nodes.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/13
% http://braph.org/

rin = min(eccentricity_in(A,type));

end