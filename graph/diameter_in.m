function din = diameter_in(A, type)
% DIAMETER_IN in-diameter of a graph
%
% DIN = DIAMETER_IN(A, TYPE) calculates the in-diameter DIN of the
%   graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The in-diameter of a graph is the maximum in-eccentricity of its nodes.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/13
% http://braph.org/

din = max(eccentricity_in(A,type));

end