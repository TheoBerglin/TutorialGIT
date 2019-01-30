function outdeg = degree_out( A, ~ )
% DEGREE_OUT Out-degree of a node
%
% OUTDEG = DEGREE_OUT(A, ~) calculates the out-degree OUTDEG of
%   all nodes in the graph represented by the connectivity matrix A.
%   The input parameter ~ specifies that this function is independent of
%   the graph type
%
% The out-degree is the number of outward edges connected to a node.
% It is the number of non-zero values in the row of A corresponding to
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

outdeg = sum(A,2)';  % outdegree = row sum of A

end

