function t = transitivity( A, type )
% TRANSITIVITY transitivity of a graph
%
% T = TRANSITIVITY(A, TYPE) calculates the transitivity of a graph
%   represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% Transitivity of a graph is defined as the fraction of triangles to
%   triplets in a graph. In weighted graphs, a contribution of a triangle
%   is defined as the geometric mean of the weigths of the edges forming
%   the triangle.
%
% A triplet for directed graphs is 3 nodes i,j and k connected such that
%   i->j->k and not i->j<-k. This is due to our calculation of closed
%   triangles, i.e. we only count triangles as i->j->k->i.
%
% Reference: "Ego-centered networks and the ripple effect", M.E.J. Newman
% https://www.stat.washington.edu/people/pdhoff/courses/567/Notes/l16_transitivity.pdf
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/31
% http://braph.org/

A = remove_diagonal(A);
A = normalize_matrix(A); % As we normalize the weights when calculating triangles we have to do this, binary won't change

tri = triangles(A, type);
A2 = abs(A).^(1/2).*sign(A); % Binary matrix won't change, signed networks work
A2 = A2^2;
denom = sum(sum(A2))-trace(A2); % Trace for i->j->i triplets, we shouldn't calculate these
t = sum(tri)/denom;

if Graph.is_undirected(type)
    t = 2*t; % Times 2 due to two directions, clockwise and counter clockwise and function Triangles divides by two.
end

if isnan(t)
    t = 0;
end

end