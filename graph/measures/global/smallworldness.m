function sw = smallworldness( A, type )
% SMALLWORLDNESS small-worldness of a graph
%
% SW = SMALLWORLDNESS(A, TYPE) calculates the small-worldness of the
%   graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/25
% http://braph.org/

M = 100;  % number of random graphs

C = clustering_global(A, type);
L = characteristic_pathlength(A, type);

Cr = zeros(1,M);
Lr = zeros(1,M);
for m = 1:1:M
    gr = randomize(A, type);
    Cr(m) = clustering_global(gr, type);
    Lr(m) = characteristic_pathlength(gr, type);
end
Cr = mean(Cr);
Lr = mean(Lr);

sw = (C/Cr)/(L/Lr);

end

