function d = density(A, ~)
% DENSITY density of a graph
%
% D = DENSITY(A, ~) calculates the density D of the graph represented
%   by the adjacency matrix A. This calculation is type independent.
%
% The density is the number of edges in the graph divided
%   by the maximum number of possible edges.
%   Self connections are removed prior to calculations.
%
% Could be changed for weighted graphs according to:
% https://academic.oup.com/bioinformatics/article/25/15/1891/211634
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/13
% http://braph.org/

A = remove_diagonal(A);
N = size(A,1);  % number of nodes
d = 100*numel(find(A~=0))/(N*(N-1));

end