function outstr = strength_out(A, ~)
% STRENGTH_OUT Out strength of a node
%
% OUTSTR = STRENGTH_OUT(A, ~) calculates the out-strength OUTSTR of all nodes
%   of the graph represented by the adjacency matrix A.
%   The input parameter ~ specifies that this function is independent of
%   the graph type.
%
% The out-strength is the sum of weights of the outwards edges. Thgese  are
% the values in the row of A corresponding to each node.
%
% In these calculations, the diagonal of the connection matrix is removed
% i.e. self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/30
% http://braph.org/

A = remove_diagonal(A);
outstr = sum(A,2)'; % The out-strength is the sum of the rows

end

