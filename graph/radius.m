function r = radius(A, type)
% RADIUS radius of a graph
%
% R = RADIUS(A, TYPE) calculates the radius R of the graph represented by
%   the adjacency matrix A. 
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The radius of a graph is the minimum eccentricity of its nodes.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/05
% http://braph.org/

r = min(eccentricity(A,type));

end

