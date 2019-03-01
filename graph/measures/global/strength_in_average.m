function res = strength_in_average( A, type)
% STRENGTH_IN_AVERAGE average of the in-strength of a node
%
% RES = STRENGTH_IN_AVERAGE(A, ~) calculates the average of the in-strength 
%   of all nodes of the graph represented by the adjacency matrix A.
%   The input parameter ~ specifies that this function is independent of
%   the graph type.
%
% The in-strength is the sum of weights of the inwards edges. Thgese  are
% the values in the column of A corresponding to each node.
%
% In these calculations, the diagonal of the connection matrix is removed
% i.e. self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

res = mean(strength_in(A, type));
