function [R,eff] = randmio_und_signed_edit(W)
% RANDMIO_UND_SIGNED_EDIT Random graph with preserved signed degree 
% distribution
%
%   R       = randmio_und_signed_edit(W);
%   [R,eff] = randmio_und_signed_edit(W);
%
%   This function randomizes an undirected network with positively and
%   negatively signed connections, while preserving the positively and
%   negatively signed degree distribution. The function does not preserve
%   the strength distribution in weighted networks.
%
%   Input:      W,      undirected (binary/weighted) connection matrix
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
%
%   2019
%   Adam Liberda & Theo Berglin, Chalmers U

%   Modification History:
%   Mar 2011: Original (Dani Bassett, based on randmio_und.m)
%   Mar 2012: Limit number of rewiring attempts,
%             count number of successful rewirings (Olaf Sporns)
%   Dec 2015: Rewritten the core of the rewiring algorithm to allow
%             unbiased exploration of all network configurations. The new
%             algorithm allows positive-positive/negative-negative
%             rewirings, in addition to the previous positive-positive/0-0
%             and negative-negative/0-0 rewirings (Mika Rubinov). 
%   May 2019: Rewritten the algorithm to randomly select two edges instead
%             of randomly selecting four nodes and checking for connections
%             between these. (Adam Liberda, Theo Berglin)

if nargin('randperm')==1
    warning('This function requires a recent (>2011) version of MATLAB.')
end

ITER = 5;
R     = double(W); % sign function requires double input
n     = size(R,1);

% maximal number of rewiring attempts per 'iter'
maxAttempts = round(n/2);
% actual number of successful rewirings
eff = 0;
edges = find(W);
n_edges = length(edges);
ITER =ITER*n_edges;

for iter=1:ITER
    att=0;
    while (att<=maxAttempts) %while not rewired
        %select two edges        
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
                b ~= c && d~=a % Self connections
            R(a,d)=r0_ab; R(a,b)=r0_ad;
            R(d,a)=r0_ab; R(b,a)=r0_ad;
            e1 = sub2ind([n,n], a, d);
            edges(nodes(1)) = e1;
            edges(edges == sub2ind([n,n], b,a)) = sub2ind([n,n], d,a);
            R(c,b)=r0_cd; R(c,d)=r0_cb;
            R(b,c)=r0_cd; R(d,c)=r0_cb;
            e2 = sub2ind([n,n], c, b);
            edges(nodes(2)) = e2;
            edges(edges == sub2ind([n,n], d,c)) = sub2ind([n,n], b,c);
            eff = eff+1;
            break;
        end %rewiring condition
        att=att+1;
    end %while not rewired
end %iterations