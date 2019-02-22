function clnode = clustering_nodal( A, type )
% CLUSTERING_NODAL cluster coefficient of each node of a graph
%
% CLNODE = CLUSTERING_NODAL(A, TYPE) calculates the cluster coefficient
%   CLNODE of each node of the graph represented by the adjacency matrix A.
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
% Date: 2019/02/05
% http://braph.org/

if Graph.is_undirected(type)
    t = triangles(A, type);
    deg = degree(A, type);
    deg(t==0) = inf; % If we have no triangles, the cluster coefficient of that node should be zero
    clnode = 2.*t./(deg.*(deg-1));
    
elseif Graph.is_directed(type)
    t = triangles(A, type); % Takes care of negative values
    
    dii = diag((remove_diagonal(A)~=0)^2)'; % To remove i->j->i triangles regardless of sign
    dout = degree_out(A, type);
    dout(t==0) = inf; % If we have no triangles, the cluster coefficient of that node should be zero
    din = degree_in(A, type);
    din(t==0) = inf; % If we have no triangles, the cluster coefficient of that node should be zero
    denom = din.*dout-2*dii; % Count only cycle triangles
    clnode = t./denom;
    
else
    error('Not implemented for this graph type')
end
end