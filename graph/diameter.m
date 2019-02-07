function d = diameter(A, type)
% DIAMETER diameter of a graph
%
% D = DIAMETER(A, TYPE) calculates the diameter D of the graph represented
%   by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The diameter of a graph is the maximum eccentricity of its nodes.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/06
% http://braph.org/

d = max(eccentricity(A,type));

end

