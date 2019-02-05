function deg = degree( A, type )
% DEGREE degree of a node
%
% DEG = DEGREE(A, TYPE) calculates the degree DEG of all nodes
%   in the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The node degree is the number of edges connected to a node with non-zero
% weight.
%
% In these calculations, the diagonal of the connection matrix is removed
% so that self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/29
% http://braph.org/

deg = degree_in(A, type) + degree_out(A, type);

if Graph.is_undirected(type)
    deg = deg/2;
end

end