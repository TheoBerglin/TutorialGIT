function indeg = degree_in( A, ~ )
% DEGREE_IN In-degree of a node
%
% INDEG = DEGREE_IN(A, ~) calculates the in-degree INDEG of all
%   nodes in the graph represented by the connectivity matrix A.
%   The input parameter ~ specifies that this function is independent of
%   the graph type.
%
% The in-degree is the number of inward edges connected to a node. 
% It is the number of non-zero values in the column of A corresponding to
% each node.
%
% In these calculations, the diagonal of the connection matrix is removed
% i.e. self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/29
% http://braph.org/

A = double(A~=0);  % binarizes connection matrix
A = remove_diagonal(A);

indeg = sum(A,1);  % in-degree = column sum of A

end

