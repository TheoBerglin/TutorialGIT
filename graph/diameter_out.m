function dout = diameter_out(A, type)
% DIAMETER_OUT out-diameter of a graph
%
% DOUT = DIAMETER_OUT(A, TYPE) calculates the out-diameter DOUT of the
%   graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-diameter of a graph is the maximum out-eccentricity of its nodes.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/13
% http://braph.org/

dout = max(eccentricity_out(A,type));

end