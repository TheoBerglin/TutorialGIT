function r = assortativity_in_out( A, type )
% ASSORTATIVITY_IN_OUT in-out-assortativity of a graph
%
% R = ASSORTATIVITY_IN_OUT(A, TYPE) calculates the in-out-assortativity
%   coefficient r of the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The assortativity coefficient is a correlation coefficient between the
%   strenghts of all nodes on two opposite ends of a link. A positive
%   assortativity coefficient indicates that nodes tend to link to other
%   nodes with the same or similar strength.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/12
% http://braph.org/

A = remove_diagonal(A);

if Graph.is_undirected(type)
    [i,j] = find(triu(A) ~= 0);
else % Graph is directed
    [i,j] = find(A ~= 0);
end

M = length(i); % Number of edges

if Graph.is_binary(type)
    deg_in = degree_in(A, type);
    deg_out = degree_out(A, type);
    ki = deg_in(i);
    kj = deg_out(j);
    r = pearson_correlation(ki, kj, M);
    
elseif Graph.is_weighted(type)
    str_in = strength_in(A, type);
    str_out = strength_out(A, type);
    ki = str_in(i);
    kj = str_out(j);
    r = pearson_correlation(ki, kj, M);
end

end