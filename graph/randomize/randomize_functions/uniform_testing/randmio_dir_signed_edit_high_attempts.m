function [R,eff] = randmio_dir_signed_edit_high_attempts(W)
% RANDMIO_DIR_SIGNED        Random directed graph with preserved signed
%                           in/out degree distribution
%
%   R       = randmio_dir(W, ITER);
%   [R,eff] = randmio_dir(W, ITER);
%
%   This function randomizes a directed weighted network with positively and
%   negatively signed connections, while preserving the positively and
%   negatively signed in- and out-degree distributions. In weighted
%   networks, the function preserves the out-strength but not the
%   in-strength distributions.
%
%   Input:      W,      directed (binary/weighted) connection matrix
%               ITER,   rewiring parameter
%                       (each edge is rewired approximately ITER times)
%
%   Output:     R,      randomized network
%               eff,    number of actual rewirings carried out
%
%   Reference:  Maslov and Sneppen (2002) Science 296:910
%
%
%   2011-2015
%   Dani Bassett, UCSB
%   Olaf Sporns,  Indiana U
%   Mika Rubinov, U Cambridge

%   Modification History:
%   Mar 2011: Original (Dani Bassett, based on randmio_und.m)
%   Mar 2012: Limit number of rewiring attempts,
%             count number of successful rewirings (Olaf Sporns)
%   Dec 2015: Rewritten the core of the rewiring algorithm to allow
%             unbiased exploration of all network configurations. The new
%             algorithm allows positive-positive/negative-negative
%             rewirings, in addition to the previous positive-positive/0-0
%             and negative-negative/0-0 rewirings (Mika Rubinov). 

if nargin('randperm')==1
    warning('This function requires a recent (>2011) version of MATLAB.')
end
ITER =5;
R = double(W);              % sign function requires double input
n = size(R,1);
ITER=ITER*n*(n-1);
org = R;
%ITER=1;

% maximal number of rewiring attempts per 'iter'
maxAttempts=10*n;
% actual number of successful rewirings
eff = 0;
edges = find(W);
n_edges = length(edges);
ITER =ITER*n_edges; % Better number of iterations
for iter=1:ITER
    att=0;
    while (att<=maxAttempts)                                     %while not rewired
        %select four distinct vertices
      
        nodes = randperm(n_edges,2);
        
        [a, b] = ind2sub([n,n],edges(nodes(1)));
        [c, d] = ind2sub([n,n],edges(nodes(2)));
        
        r0_ab = R(a,b);
        r0_cd = R(c,d);
        r0_ad = R(a,d);
        r0_cb = R(c,b);
        
        %rewiring condition
        if      (sign(r0_ab)==sign(r0_cd)) && ...
                (sign(r0_ad)==sign(r0_cb)) && ...
                (sign(r0_ab)~=sign(r0_ad)) && ...
            a ~= d && c~=b
                
            
            R(a,d)=r0_ab;
            e1 = sub2ind([n,n], a, d);
            edges(nodes(1)) = e1;
            R(a,b)=r0_ad;
            R(c,b)=r0_cd;
            e2 = sub2ind([n,n], c, b);
            edges(nodes(2)) = e2;
            R(c,d)=r0_cb;
            
            eff = eff+1;
            break;
        end %rewiring condition
        att=att+1;
    end %while not rewired
end %iterations