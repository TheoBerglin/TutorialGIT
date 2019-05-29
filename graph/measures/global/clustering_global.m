function res = clustering_global( A, type)
% CLUSTERING_GLOBAL global clustering measure
%
% RES = CLUSTERING_GLOBAL(A, TYPE) calculates the average of the 
%   cluster coefficient of each node of the graph represented by 
%   the adjacency matrix A. This is the global clustering coefficient.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% Clustering coefficient of a node is defined as the fraction of triangles
%   around the node (the fraction of node's neighbors that are neighbors of
%   each other).
%
% In weighted graphs, a contribution of a triangle is defined as the
%   geometric mean of the weigths of the edges froming the triangle.
%
% Reference: "Intensity and coherence of motifs in weighted complex networks", J.P.Onnela et al.
%            "Clustering in complex directed networks", G.Fagiolo
% Negative undirected: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3931641/
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/28
% http://braph.org/

res = mean(clustering_nodal(A, type));
