function instr = strength_in(A, ~)
% STRENGTH_IN In strength of a node
%
% INSTR = STRENGTH_IN(A, ~) calculates the in-strength INSTR of all nodes of
%   the graph represented by the adjacency matrix A.
%   The input parameter ~ specifies that this function is independent of
%   the graph type.
%
% The in-strength is the sum of weights of the inwards edges.
%
% In these calculations, the diagonal of the connection matrix is removed
% i.e. self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/30
% http://braph.org/

A = remove_diagonal(A);
instr = sum(A,1); % The in-strength is the sum of the columns

end

