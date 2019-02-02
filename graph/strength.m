function str = strength(A, type)
% STRENGTH Strength of a node
%
% STR = STRENGTH(A, TYPE) calculates the strength STR of all nodes of
%   the graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The strength is the sum of weights of the inwards and outwards edges.
%
% In these calculations, the diagonal of the connection matrix is removed
% i.e. self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/31
% http://braph.org/

str = strength_in(A)+strength_out(A);

if type == Graph.WU || type == Graph.BU || type == Graph.WUN
    str = str / 2;
end

end

