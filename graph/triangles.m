function t = triangles( A, type )
% TRIANGLES Number of triangles around a node
%
% T = TRIANGLES(A, TYPE) calculates the number of triangles T
%   around all nodes in the graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% For binary graphs, the number of triangles are the number of pairs of
% neighbours of a node that are connected with each other.  
% For weighted graphs, the number of triangles is defined as the geometric
% mean of the weights forming the triangles. In directed graphs, a triangle
% is considered only if the directions between the three nodes (vertices of
% the triangle) are arranged as a cycle i.e. each one of the nodes has one
% incoming and one outgoing edge. Thus, each set of 3 nodes contributes to
% 1 triangle. Negative weights will be handled in the same way as positive
% weights, i.e, two negative connections will result in a positive triangle
% while one or three negative connections will result in a negative
% triangle.
%
% In these calculations, the diagonal of the connection matrix is removed,
% i.e. self-connections are not considered. 
%
% Reference on calculations: 
% * J.P.Onnela et al. "Intensity and coherence of motifs in weighted complex networks"
% * G.Fagiolo, "Clustering in complex directed networks"
% * Negative matrix: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3931641/
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/31
% http://braph.org/

A = remove_diagonal(A);
A = normalize_matrix(A); % Normalize the matrix needed for weighted calculations, Binary matrix won't change
N = size(A,2); % Number of nodes

if Graph.is_undirected(type)
    A13 = abs(A).^(1/3).*sign(A); % No imaginary numbers for negative matrix, Binary matrix won't change
    A3 = A13^3;
    t = diag(A3)'/2;
    
else % Graph is directed
    t = zeros(1,N);
    W = abs(A).^(1/3).*sign(A); % No imaginary numbers for negative matrix, Binary matrix won't change
    for u = 1:1:N
        nodesout = find(W(u,:));
        nodesin = find(W(:,u))';
        if ~isempty(nodesout) && ~isempty(nodesin)
            % We have a triangle if one of the out nodes goes to the one of the in nodes
            % u--> out-node --> in-node --> u
            temp_num = W(u,nodesout)*W(nodesout,nodesin)*W(nodesin,u);
            t(u) = sum(sum(temp_num));
        end
    end
end

end

