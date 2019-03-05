function res = strength_out_average( A, type)
% STRENGTH_OUT_AVERAGE average of the out-strength of a node
%
% RES = STRENGTH_OUT_AVERAGE(A, ~) calculates the average of the out-strength 
%   of all nodes of the graph represented by the adjacency matrix A.
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
% Date: 2019/03/01
% http://braph.org/

res = mean(strength_out(A, type));
