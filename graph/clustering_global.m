function cl = clustering_global( A, type )
% CLUSTERING_GLOBAL cluster coefficient of a graph
%
% CL = CLUSTERING_GLOBAL(A, TYPE) calculates the cluster coefficient CL
%   of a graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% Clustering coefficient of a graph is the mean of the clustering
%   coefficient of each node of the graph.
%
% Clustering coefficient of a node is defined as the fraction of triangles
%   around the node (the fraction of node's neighbors that are neighbors of
%   each other).
%
% In weighted graphs, a contribution of a triangle is defined as the
%   geometric mean of the weigths of the edges forming the triangle.
%
% Reference: "Intensity and coherence of motifs in weighted complex networks", J.P.Onnela et al.
%            "Clustering in complex directed networks", G.Fagiolo
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/07
% http://braph.org/

clnode = clustering_nodal(A, type);
cl = mean(clnode);

end