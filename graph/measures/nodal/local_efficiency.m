function lenode = local_efficiency( A, type )
% LENODE local efficiency of each node
%
% LENODE = LOCAL_EFFICIENCY(A,TYPE) calculates the local efficiency
%   LENODE of each node in the graph represented by the adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The local efficiency of a node is the global efficiency calculated
%   on the subgraph created by the neighbours of the node and is related
%   to the clustering coefficient.  That is the local efficiency of a node i
%   characterizes how well information is exchanged by its neighbors when it is removed.
%
% In these calculations, the diagonal of connection matrix is removed i.e.
%   self-connections are not considered.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/11
% http://braph.org/

N = size(A, 1);  % nbr of nodes
lenode = zeros(1,N);

if Graph.is_binary(type)
    A = remove_diagonal(A);
    A = double(A>0);
    
    for u = 1:1:N
        nodes = find(A(u,:) | A(:,u).');  % neighbours of u
        adjac_sym = A(u, nodes) + A(nodes, u).'; % symmetrized adjacency vector
        
        d = distance(A(nodes, nodes), type);
        di = 1./d; % inverse distance matrix
        di = remove_diagonal(di);
        
        di_sym = di+di.'; %symmetrized inverse distance matrix
        numer = sum(sum((adjac_sym.'*adjac_sym).*di_sym))/2; %numerator
        if numer~=0
            denom = sum(adjac_sym).^2 - sum(adjac_sym.^2);  %denominator
            lenode(u) = numer/denom;
        end
    end
    
elseif Graph.is_weighted(type) && Graph.is_positive(type)
    A_cuberoot = A.^(1/3);
    A = double(A>0);
    
    for u = 1:1:N
        nodes = find(A(u,:)|A(:,u).');  % find neighbours
        weights_sym = A_cuberoot(u, nodes) + A_cuberoot(nodes, u).';  % symmetrized weights vector
        
        d = distance(A_cuberoot(nodes, nodes), type);
        di = 1./d; % inverse distance matrix
        di = remove_diagonal(di);
        
        di_sym = di + di.'; % symmetrized inverse distance matrix
        numer = (sum(sum((weights_sym.' * weights_sym) .* di_sym)))/2; % numerator
        if numer~=0
            adjac_sym = A(u, nodes) + A(nodes, u).'; % symmetrized adjacency vector
            denom = sum(adjac_sym).^2 - sum(adjac_sym.^2); % denominator
            lenode(u) = numer / denom;
        end
    end
    
elseif Graph.is_negative(type)
    error('Negative weights, not implemented')
end

end