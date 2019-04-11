function [E,mw,rw] = randomize_braph_BU_bias_fix(A,I,error)
% RANDOMIZE_BRAPH_BU calculates a random binary undirected matrix
%
% E = RANDOMIZE_BRAPH_BU(A) calculates a random binary undirected matrix
%   preserving the degree of each node.
%   Therefore, also the degree distribution is preserved.
%
% [E,MW] = RANDOMIZE_BRAPH_BU(A,I,ERROR) permits one to set
%   the maximum number of iterations I (default I=100) and
%   the maximum fraction of miswired edges ERROR (default ERROR = 1e-4,
%   i.e. at most one edge out of 10000 is miswired).
%   MW is the number of miswired edges that are eliminated.
%
% Conditions on the input connectivity matrix A:
%   (1) A is square
%   (2) A(r,c) = 0, 1 or -1
%   (3) A(r,r) = 0 (no self-connection)
%   (4) A(r,c) = A(c,r) (symmetric)
%
% Notes on the algorithm:
%   A is considered as a directed matrix and a random directed matrix B is
%   generated using rand_bd.
%   The connected nodes of B can be connected by two equal edges
%   (bi-directional), two unequal edges (in case of negative networks)
%   or by one edge (one-directional). Since the number of incoming and
%   outgoing edges is conserved, the one-directional edges are arranged in
%   cycles. Half of the one-directional edges are eliminated and the other
%   hals is transformed into bi-directional edges. In case of negative
%   networks, half of the unequal edges are made positive and half are made
%   negative.
%   Some minor corrections might need to be applied at the end for a very
%   limited numebr of nodes.
%

% Version 1:
%   - Author: Giovanni Volpe
%   - Date: 2016/04/01
% Version 2:
%   - Authors: Adam Liberda, Theo Berglin
%   - Date: 2019/03/25

% maximum number of iterations
if nargin<2 || isempty(I)
    I = 100;
end

% maximum fraction of miswired edges
if nargin<3 || isempty(error)
    error = 1e-4;
end

% check squareness
if ~isequal(size(A,1), size(A,2))
    error('Input matrix needs to be square');
end

% check "binarism"
if ~all(all(A == 0 | A == 1 | A == -1))
    error('Input matrix does not consist of -1, 1 or 0');
end

% check for symmetry
if ~isequal(A, A.')
    error('Input matrix is not symmetric');
end

% number of nodes
N = length(A);

% check for self-connections and remove these if they exist
if ~all(A(1:N+1:end) == 0)
    A = remove_diagonal(A);
end

% binary directed random matrix
B = randomize_braph_BD(A,I,error);

% find where 2 non-zero edges create zero-sum cycles
B_pos = B == 1;
B_neg = B == -1;
B_double_sign = transpose(B_pos) & (B_neg);

% make half of these edges negative, and other half positive
counter = 1;
for i = find(B_double_sign).'
    [row, col] = ind2sub(size(B), i);
    B_neg(row, col) = mod(counter, 2);
    B_neg(col, row) = mod(counter, 2);
    B_pos(row, col) = mod(counter-1, 2);
    B_pos(col, row) = mod(counter-1, 2);
    counter = counter + 1;
end

% matrix with the bi-directional edges
% symmetric, i.e. D = transpose(D)
D_pos = floor((B_pos+transpose(B_pos))/2);
D_neg = floor((B_neg+transpose(B_neg))/2);
D = {D_pos, D_neg};

% matrix with the one-directional edges
% antisymmetric, i.e. C = -transpose(C)
C_pos = B_pos-transpose(B_pos)==1;
C_neg = B_neg-transpose(B_neg)==1;
C = {C_pos, C_neg};

% correct the one-directional edges
% it relies on the fact that the number of incoming and outgoing edges is
% conserved and therefore the edges are arranged in cycles
for i = [1 2]
    C_curr = C{i};
    counter = sum(C_curr(:)); % number of one-directional edges that need to be corrected
    D_curr = D{i};
    max_iter = nnz(C_curr) * 5;
    overall_counter = 0;
    while counter
        overall_counter = overall_counter +1;
        
        r = randi(N); % choose a random row (start node)
        cs = find(C_curr(r,:)); % select all the corresponding end nodes
        if overall_counter > max_iter
            while ~isempty(cs)
                % select random end node
                c = cs(1); % c = cs(randi(length(cs))); % for computational efficiency
                
                % erase edge or make it bi-directional
                D_curr(r,c) = mod(counter,2);
                D_curr(c,r) = mod(counter,2);
                
                % erase edge from C matrix
                C_curr(r,c) = 0;
                
                counter = counter-1;
                
                r = c; % update row (start node)
                cs = find(C_curr(r,:)); % select all the corresponding end nodes
                
            end
        else
            node_path = zeros(1, N+1);
            node_path(1) = r;
            index = 1;

            % move along a cycle (i.e. a series of nodes connected by forward connections)
            % (1) when counter is odd, erase the edge
            % (2) when counter is even, make the edge bidirectional
            C_curr_temp = C_curr;
            while ~isempty(cs)
                index = index + 1;
                % select random end node
                c = cs(1); % c = cs(randi(length(cs))); % for computational efficiency
                node_path(index) = c;

                % erase edge from C matrix
                C_curr_temp(r,c) = 0;

                r = c; % update row (start node)
                cs = find(C_curr_temp(r,:)); % select all the corresponding end nodes
            end

            if mod(nnz(node_path), 2) && nnz(node_path) > 1
                C_curr = C_curr_temp;
                node_path = node_path(node_path>0);
                for j=1:length(node_path)-1
                    % erase edge or make it bi-directional
                    D_curr(node_path(j),node_path(j+1)) = mod(counter,2);
                    D_curr(node_path(j+1),node_path(j)) = mod(counter,2);

                    counter = counter-1;
                end
            end
        end
    end
    D{i} = D_curr;
end

% merge positive and negative edges
E = zeros(size(B));
E(logical(D{1})) = 1;
E(logical(D{2})) = -1;

% correct the remaining wrong edges (typically < 10 for a number of nodes up to 1000)
% these are due to the fact that some cycle have odd numbers
rw = 0;

for i = 1:1:10
    
    dev = sum(E~=0)-sum(A~=0);
    
    indp = find(dev>0);
    indm = find(dev<0);
    
    if isempty(indp) || isempty(indp)
        break
    end
    
    rw = rw+1;
    rp = indp(randi(length(indp)));
    rm = indm(randi(length(indm)));
    
    c = find(E(:,rp)~=0);
    c = c(randi(length(c)));
    
    if E(rm,c)==0 && rm~=c && rp~=c && rp~=rm
        E(rm,c) = E(rp,c);
        E(c,rm) = E(c, rp);
        
        E(rp,c) = 0;
        E(c,rp) = 0;
    end
    
end

% calculate number of miswired edges
mw = sum(abs(sum(A)-sum(E)))/2;
end