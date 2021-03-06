function D = distance( A, type )
% DISTANCE shortest path length of nodes from each other
%
% D = DISTANCE(A, TYPE) returns the distance matrix D which contains
%   lengths of shortest paths between all pairs of nodes in the graph
%   represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% An entry (u,v) represents the length of the shortest path from node u
%   to node v. In the case of binary graphs, the length of a path is the
%   number of edges. In the case of weighted graphs, the shortest paths
%   have the minimum weighted distance, which is inversely proportional
%   to the weight, i.e a higher weight implies a shorter connection.
%   Note that the minimum weighted distance is not necessarily the
%   minimum number of edges. The calculation for graphs with negative
%   weights is not implemented and returns a matrix containing zeros.
%
% Lengths between disconnected nodes are set to Inf. Lengths on the main
%   diagonal are set to 0.
%
% The algorithm used is a breadth-first search for binary graphs and
%   Dijkstra's algorithm for the weighted graphs.
%
% Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
%            and M.J. Mossinghoff
%            "Complex network measures of brain connectivity: Uses and
%            interpretations", M.Rubinov and O.Sporns
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/31
% http://braph.org/

if Graph.is_binary(type)
    l = 1;  % path length
    D = A;  % distance matrix
    
    l_path = A;
    idx = true;
    while any(idx(:))
        l = l+1;
        l_path = l_path*A;
        idx = (l_path~=0)&(D==0);
        D(idx) = l;
    end
    
    D(~D) = inf;  % assign inf to disconnected nodes
    D = remove_diagonal(D);  % assign 0 to the diagonal
    
elseif Graph.is_weighted(type) && Graph.is_positive(type)
    L = A;  % length matrix
    ind = L~=0;
    L(ind) = L(ind).^-1;  % length is inversely prop to weights
    
    n = length(L);
    D = inf(n);
    D(1:n+1:end) = 0;  % distance matrix
    
    for u = 1:n  % loop through nodes
        S = true(1,n);  % distance permanence (true is temporary)
        L1 = L;
        V = u;
        
        while 1
            S(V) = 0;  % distance u->V is now permanent
            L1(:,V) = 0;  % no in-edges as already shortest
            
            for v = V
                T = find(L1(v,:));  % neighbours of shortest nodes
                [d, ~] = min([D(u,T);D(u,v)+L1(v,T)]);
                D(u,T) = d;  % smallest of old/new path lengths
            end
            
            minD = min(D(u,S));
            if isempty(minD) || isinf(minD)  % isempty: all nodes reached;
                break,  % isinf: some nodes cannot be reached
            end
            
            V = find(D(u,:)==minD);
        end
        
    end
    
elseif Graph.is_negative(type)
    error('Negative weights, not implemented')
end

end

