function res = degree_out_average( A, type)
% DEGREE_OUT_AVERAGE average of the out-degree of a node
%
% RES = DEGREE_OUT_AVERAGE(A, ~) calculates the average of the out-degree of
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
% Date: 2019/03/01
% http://braph.org/

res = mean(degree_out(A, type));
