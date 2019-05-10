function [B, mw] = randomize_braph_BD(A,I,error)
% RANDOMIZE_BRAPH_BD calculates a random binary directed matrix
%
% B = RANDOMIZE_BRAPH_BD(A) calculates a random binary directed matrix
%   preserving the in-degree and out-degree of each node.
%   Therefore, also the in-degree and out-degree distributions are preserved.
%
% [B, mw] = RANDOMIZE_BRAPH_BD(A,I,ERROR) permits one to set
%   the maximum number of iterations I (default I=100) and
%   the maximum fraction of miswired edges ERROR (default ERROR = 1e-4,
%   i.e. at most one edge out of 10000 is miswired).
%   MW is the number of miswired edges that are eliminated.
%
% Conditions on the input connectivity matrix A:
%   (1) A is square
%   (2) A(r,c) = 0 or 1
%   (3) A(r,r) = 0 (no self-connection)
%
% Notes on the algorithm:
%   Almost all edges are rewired at once. This implies that some edges
%   might be miswired because (1) they are self-connections
%   or (2) they are duplicated.
%   The algorithm iteratively rewires these miswired edges
%   until the maximum number of iterations (I) or the acceptable maximum
%   fraction of miswired edges (number of edges * ERROR) is reached.
%   At the end, the miswired edges are eliminated.
%

% Version 1:
%   - Author: Giovanni Volpe
%   - Date: 2016/04/01
% Version 2:
%   - Authors: Adam Liberda, Theo Berglin
%   - Date: 2019/03/13

% maximum number of iterations
if nargin<2 || isempty(I)
    I = 100;
end

% maximum fraction of miswired edges
if nargin<3 || isempty(error)
    error = 1e-4;
end

% % check squareness
% if ~isequal(size(A,1), size(A,2))
%     error('Input matrix needs to be square');
% end
% 
% % check "binarism"
% if any(find(A ~= 0 & A ~= 1))
%    error('Input matrix is not binary');
% end

% number of nodes
N = length(A);

% check for self-connections and remove these if they exist
if ~all(A(1:N+1:end) == 0)
    A = remove_diagonal(A);
end

% find edge indexes
e = find(A); % e = (c-1)*N+r

% find column (incoming) and row (outgoing) indexes of the edges
c = floor((e-1)/N)+1;
r = e-(c-1)*N;

% number of edges
E = length(e);

% randomly permutate the row (outgoing) indexes of the edges
% this step potentially rewires all the edges
permutation(1:1:E)

% try to rewire the miswired edges until the maximum number of iterations
% or the acceptable maximum fraction of miswired edges is reached.
for i = 1:1:I
    ind_mw = miswired();
    permutation(ind_mw)
    
    if length(ind_mw)<E*error
        break
    end
end

% eliminate remaining miswired edges
ind_mw = miswired();
e(ind_mw) = 0;
c(ind_mw) = 0;
r(ind_mw) = 0;

ind = find(e~=0);
e = e(ind);
c = c(ind);
r = r(ind);

% number of miswired edges
mw = length(ind_mw);

    function permutation(ind)
        % permutes the edges with indices ind
        
        % randomly permutate the row (outgoing) indexes of the edges
        % this step potentially rewires all the edges
        % the column (incoming) indexes are left unchanged without loss of generality
        rt = r(ind);
        new_indices = randperm(length(rt));
        r(ind) = rt(new_indices);
        e(ind) = (c(ind)-1)*N+r(ind);        
        
        % sorts e, r, c increasingly as a function of the edge indexes (e)
        [e,i] = sort(e);
        r = r(i);
        c = c(i);
    end

    function ind_mw = miswired()
        % ind_mw returns the miswired edges
        
        % find the indexes of the self-connected edges
        ind_diag = find(r==c);
        
        % find the indexes of the duplicated connections
        ind_rep = find(diff(e)==0)+1;
        
        % create a vector will the indexes of all miswired edges
        ind_mw = unique([ind_diag; ind_rep]);
        
        % add a random edge in order to prevent the optimization from getting stuck
        if ~isempty(ind_mw)
            ind_mw = unique([ind_mw; randi(E)]);
        end
    end

% construct the connectivity matrix B with rewired edges
B = sparse(size(A,1), size(A,2));
B(sub2ind(size(B),r,c)) = 1;

end