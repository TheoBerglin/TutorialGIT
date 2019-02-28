function B = betweenness( A, type )
% BETWEENNESS betweenness centrality of nodes
%
% B = BETWEENNESS( A, type ) calculates the normalized betweenness
%   centrality B of all nodes of the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% Betweenness centrality of a node is defined as the fraction of
%   all shortest paths in a graph that contain that node but don't
%   start from or end at that node. Note that the number of possible
%   paths is (n-1)*(n-2).
%
%  A node that has a high value of betweenness centrality participates in
%   a large number of shortest paths.
%
% It exists a bug in regards to the  number of shortest paths for weighted
%   graphs in the case of multiple shortest paths. Only one of the paths
%   contribute to the number of possible paths.
%
% The function isn't implemented for negative matrices until we
%   have a sufficient distance method for negative matrices. As of now
%   it will return an error.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/06
% http://braph.org/

if Graph.is_binary(type)
    N = size(A,1);  % number of nodes
    I = eye(N)~=0;  % logical identity matrix
    d = 1;  % Start path length
    NPd = A;  % number of paths of length |d|
    NSPd = NPd;  % number of shortest paths of length |d|
    NSP = NSPd; NSP(I) = 1;  % number of shortest paths of any length
    L = NSPd;
    L(I) = 1;  % length of shortest paths
    
    % calculate number of shortest paths and L
    % Compute path count
    while find(NSPd,1)
        d = d+1;
        NPd = NPd*A; % Index value corresponds to number of paths found of length d+1
        NSPd = NPd.*(L==0); % Add only number of shortest paths for i->j previously not found
        NSP = NSP+NSPd;
        L = L+d.*(NSPd~=0); % Add new found shortest paths
    end
    L(~L) = inf; L(I) = 0;  % L for disconnected vertices is inf
    NSP(~NSP) = 1;  % NSP for disconnected vertices is 1
    
    At = A.'; % Why do we take the transpose?
    
    DP = zeros(N);  % vertex on vertex dependency
    diam = d-1;  % graph diameter
    % calculate DP
    % Backward pass
    for d = diam:-1:2 % L==d is zero for d=diam
        DPd1 = (((L==d).*(1+DP)./NSP)*At).*((L==(d-1)).*NSP);
        DP = DP + DPd1;  % DPd1: dependencies on vertices |d-1| from source
    end
    
    B = sum(DP,1);  % compute betweenness
    B = B/((N-1)*(N-2)); % Normalize
    
elseif Graph.is_weighted(type) && Graph.is_positive(type)
    N = size(A,2);
    E = find(A); A(E) = 1./A(E);  % invert weights
    BC = zeros(N,1);  % vertex betweenness
    
    for u = 1:1:N
        D = inf(1,N); D(u) = 0;  % distance from u
        NP = zeros(1,N); NP(u) = 1;  % number of paths from u
        S = true(1,N);  % distance permanence (true is temporary)
        P = false(N);  % predecessors
        Q = zeros(1,N); q = N;  % order of non-increasing distance
        
        G1 = A;
        V = u;
        while 1
            S(V) = 0;  % distance u->V is now permanent
            G1(:,V) = 0;  % no in-edges as already shortest
            for v = V
                Q(q) = v; q = q-1;
                W = find(G1(v,:));  % neighbours of v
                for w = W
                    Duw = D(v)+G1(v,w);  % path length to be tested
                    if Duw<D(w)  % if new u->w shorter than old
                        D(w) = Duw;
                        NP(w) = NP(v);  % NP(u->w) = NP of new path
                        P(w,:) = 0;
                        P(w,v) = 1;  % v is the only predecessor
                    elseif Duw==D(w)  % if new u->w equal to old
                        NP(w) = NP(w)+NP(v);  % NP(u->w) sum of old and new
                        P(w,v) = 1;  % v is also a predecessor
                    end
                end
            end
            
            minD = min(D(S));
            if isempty(minD), break  % all nodes reached, or
            elseif isinf(minD)  % some cannot be reached:
                Q(1:q) = find(isinf(D)); break  % ...these are first-in-line
            end
            V = find(D==minD);
        end
        
        DP = zeros(N,1);  % dependency
        for w = Q(1:N-1)
            BC(w) = BC(w)+DP(w);
            for v = find(P(w,:))
                DP(v) = DP(v)+(1+DP(w)).*NP(v)./NP(w);
            end
        end
    end
    B = BC';
    B = B/((N-1)*(N-2));
    
else
    error('Not implemented for negative matrices')
end
end

