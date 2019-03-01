function res = degree_in_average( A, type)
% DEGREE_IN_AVERAGE average of the in-degree of a node
%
% RES = DEGREE_IN_AVERAGE(A, ~) calculates the average of the in-degree of all
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
% Date: 2019/03/01
% http://braph.org/

res = mean(degree_in(A, type));
