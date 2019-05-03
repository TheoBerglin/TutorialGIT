function [D,mw] = randomize_braph_BU(A,I,error)
% RANDOMIZE_BRAPH_BU calculates a random binary undirected matrix
%
% D = RANDOMIZE_BRAPH_BU(A) calculates a random binary undirected matrix
%   preserving the degree of each node.
%   Therefore, also the degree distribution is preserved.
%   
% [D,MW] = RANDOMIZE_BRAPH_BU(A,I,ERROR) permits one to set
%   the maximum number of iterations I (default I=100) and 
%   the maximum fraction of miswired edges ERROR (default ERROR = 1e-4, 
%   i.e. at most one edge out of 10000 is miswired).
%   MW is the number of miswired edges that are eliminated.
%
% Conditions on the input connectivity matrix A:
%   (1) A is square
%   (2) A(r,c) = 0 or 1
%   (3) A(r,r) = 0 (no self-connection)
%   (4) A(r,c) = A(c,r) (symmetric)
%
% Notes on the algorithm:
%   A is considered as a directed matrix and a random directed matrix B is
%   generated using randomize_braph_BD.
%   The connected nodes of B can be connected by two edges
%   (bi-directional) or by one edge (one-directional). Since the number 
%   of incoming and outgoing edges is conserved, the one-directional edges
%   are arranged in cycles. Half of the one-directional edges are 
%   eliminated and the other half is transformed into bi-directional 
%   edges. 
%
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
if ~all(all(A == 0 | A == 1))
   error('Input matrix is not binary');
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


% matrix with the bi-directional edges
% symmetric, i.e. D = transpose(D)
D = floor((B+transpose(B))/2);

% matrix with the one-directional edges
% antisymmetric, i.e. C = -transpose(C)
C = B-transpose(B)==1;

% correct the one-directional edges
% it relies on the fact that the number of incoming and outgoing edges is
% conserved and therefore the edges are arranged in cycles
counter = sum(C(:)); % number of one-directional edges that need to be corrected
while counter
    r = randi(N); % choose a random row (start node)
    cs = find(C(r,:)); % select all the corresponding end nodes

    % move along a cycle (i.e. a series of nodes connected by forward connections)
    % (1) when counter is odd, erase the edge
    % (2) when counter is even, make the edge bidirectional
    while ~isempty(cs)

        % select random end node
        c = cs(1); % c = cs(randi(length(cs))); % for computational efficiency

        % erase edge or make it bi-directional
        D(r,c) = mod(counter,2);
        D(c,r) = mod(counter,2);

        % erase edge from C matrix
        C(r,c) = 0;

        counter = counter-1;

        r = c; % update row (start node)
        cs = find(C(r,:)); % select all the corresponding end nodes

    end
end

% correct the remaining wrong edges (typically < 10 for a number of nodes up to 1000)
% these are due to the fact that some cycle have odd numbers
for i = 1:1:10
    
    dev = sum(D)-sum(A);

    indp = find(dev>0);
    indm = find(dev<0);

    if isempty(indp) || isempty(indp)
        break
    end
    
    rp = indp(randi(length(indp)));
    rm = indm(randi(length(indm)));
    
    c = find(D(:,rp)==1);
    c = c(randi(length(c)));
    
    if D(rm,c)==0 && rm~=c && rp~=c && rp~=rm
        D(rp,c) = 0;
        D(c,rp) = 0;

        D(rm,c) = 1;
        D(c,rm) = 1;
    end
    
end

% calculate number of miswired edges
mw = sum(abs(sum(A)-sum(D)))/2;
end