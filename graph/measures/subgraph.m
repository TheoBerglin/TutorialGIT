function sg = subgraph( A, nodes )
% SUBGRAPH creates subgraph from given nodes
%
% SG = SUBGRAPH(A,NODES) creates the subgraph SG from the graph
%   represented by the adjacency matrix A. SG contains only the nodes
%   specified by NODES.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/07
% http://braph.org/

sg = A(nodes, nodes);

end
