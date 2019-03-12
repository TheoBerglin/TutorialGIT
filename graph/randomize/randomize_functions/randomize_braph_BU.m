function [rW,R] = randomize_braph_BU(W,bin_swaps,wei_freq)
% RANDOMIZE_BRAPH_BU randomizes the graph using the BRAPH algorithm
%
% [rW,R] = RANDOMIZE_BRAPH_BU(W,bin_swaps,wei_freq) randomizes the graph 
%   represented by the adjacency matrix W and returns the new binary undirected
%   graph rW and the correlation coefficients between strength sequences
%   of input and output connection matrices - R.
%
% Optional parameters that can be passed to the function:
%   BIN_SWAPS -    average number of swaps of each edge in binary randomization
%                  (default) bin_swap = 5 : each edge is rewired 5 times
%   WEI_FREQ  -    frequency of weight sorting in weighted randomization, must
%                  be in the range of: 0 < wei_freq <= 1
%                  (default) wei_freq = 1 : older [<2011] versions of MATLAB
%                  (default) wei_freq = .1 : newer versions of MATLAB
%
% Randomization may be better (and execution time will be slower) for
%           %   higher values of bin_swaps and wei_freq. Higher values of bin_swaps may
%           %   enable a more random binary organization, and higher values of wei_freq
%           %   may enable a more accurate conservation of strength sequences.
%
% Reference: "Weight-conserving characterization of complex functional brain
%             networks", M.Rubinov and O.Sporns
%             "Specificity and Stability in Topology of Protein Networks", S.Maslov
%             and K.Sneppen
%
% See also GraphBU.

if ~exist('bin_swaps','var')
    bin_swaps = 5;
end
if ~exist('wei_freq','var')
    if nargin('randperm')==1
        wei_freq = 1;
    else
        wei_freq = 0.1;
    end
end

if wei_freq<=0 || wei_freq>1
    error('wei_freq must be in the range of: 0 < wei_freq <= 1.')
end
if wei_freq && wei_freq<1 && nargin('randperm')==1
    warning('wei_freq may only equal 1 in older (<2011) versions of MATLAB.')
    wei_freq = 1;
end

n = size(W,1);  % number of nodes
W(1:n+1:end) = 0;  % clear diagonal

Ap = W>0;  % positive adjacency matrix
if nnz(Ap)<(n*(n-1))  % if Ap not fully connected
    n2 = size(Ap,1);
    [i2 j2] = find(tril(Ap));
    K2 = length(i2);
    bin_swaps = K2*bin_swaps;
    
    % maximal number of rewiring attempts per 'bin_swaps'
    maxAttempts = round(n2*K2/(n2*(n2-1)));
    % actual number of successful rewirings
    eff = 0;
    
    for iter = 1:bin_swaps
        att = 0;
        while (att<=maxAttempts)  % while not rewired
            while 1
                e1 = ceil(K2*rand);
                e2 = ceil(K2*rand);
                while (e2==e1),
                    e2 = ceil(K2*rand);
                end
                a = i2(e1); b = j2(e1);
                c = i2(e2); d = j2(e2);
                
                if all(a~=[c d]) && all(b~=[c d]);
                    break  % all four vertices must be different
                end
            end
            
            if rand>0.5
                i2(e2) = d; j2(e2) = c;  % flip edge c-d with 50% probability
                c = i2(e2); d = j2(e2);  % to explore all potential rewirings
            end
            
            % rewiring condition
            if ~(Ap(a,d) || Ap(c,b))
                Ap(a,d) = Ap(a,b); Ap(a,b) = 0;
                Ap(d,a) = Ap(b,a); Ap(b,a) = 0;
                Ap(c,b) = Ap(c,d); Ap(c,d) = 0;
                Ap(b,c) = Ap(d,c); Ap(d,c) = 0;
                
                j2(e1) = d;  % reassign edge indices
                j2(e2) = b;
                eff = eff+1;
                break;
            end  % rewiring condition
            att = att+1;
        end  % while not rewired
    end  % iterations
    
    Ap_r = Ap;
else
    Ap_r = Ap;
end
An =~ Ap; An(1:n+1:end) = 0;  % negative adjacency matrix
An_r =~ Ap_r; An_r(1:n+1:end) = 0;  % randomized negative adjacency

W0 = zeros(n);  % null model network
for s = [1 -1]
    switch s  % switch sign (positive/negative)
        case 1
            S = sum(W.*Ap,2);  % positive strength
            Wv = sort(W(triu(Ap)));  % sorted weights vector
            [I,J] = find(triu(Ap_r));  % weights indices
            Lij = n*(J-1)+I;  % linear weights indices
        case -1
            S = sum(-W.*An,2);  % negative strength
            Wv = sort(-W(triu(An)));  % sorted weights vector
            [I,J] = find(triu(An_r));  % weights indices
            Lij = n*(J-1)+I;  % linear weights indices
    end
    
    P = (S*S.');  % expected weights matrix
    
    if wei_freq==1
        for m = numel(Wv):-1:1  % iteratively explore all weights
            [dum,Oind] = sort(P(Lij));  % get indices of Lij that sort P
            r = ceil(rand*m);
            o = Oind(r);  % choose random index of sorted expected weight
            W0(Lij(o)) = s*Wv(r);  % assign corresponding sorted weight at this index
            
            f = 1 - Wv(r)/S(I(o));  % readjust expected weight probabilities for node I(o)
            P(I(o),:) = P(I(o),:)*f;  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            P(:,I(o)) = P(:,I(o))*f;
            f = 1 - Wv(r)/S(J(o));  % readjust expected weight probabilities for node J(o)
            P(J(o),:) = P(J(o),:)*f;  % [1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
            P(:,J(o)) = P(:,J(o))*f;
            
            S([I(o) J(o)]) = S([I(o) J(o)])-Wv(r);  % readjust strengths of nodes I(o) and J(o)
            Lij(o) = [];  % remove current index from further consideration
            I(o) = [];
            J(o) = [];
            Wv(r) = [];  % remove current weight from further consideration
        end
    else
        wei_period = round(1/wei_freq);  % convert frequency to period
        for m = numel(Wv):-wei_period:1  % iteratively explore at the given period
            [dum,Oind] = sort(P(Lij));  % get indices of Lij that sort P
            R = randperm(m,min(m,wei_period)).';
            O = Oind(R);
            W0(Lij(O)) = s*Wv(R);  % assign corresponding sorted weight at this index
            
            WA = accumarray([I(O);J(O)],Wv([R;R]),[n,1]);  % cumulative weight
            IJu = any(WA,2);
            F = 1-WA(IJu)./S(IJu);
            F = F(:,ones(1,n));  % readjust expected weight probabilities for node I(o)
            P(IJu,:) = P(IJu,:).*F;  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            P(:,IJu) = P(:,IJu).*F.';
            S(IJu) = S(IJu)-WA(IJu);  % re-adjust strengths of nodes I(o) and J(o)
            
            O = Oind(R);
            Lij(O) = [];  % remove current index from further consideration
            I(O) = [];
            J(O) = [];
            Wv(R) = [];  % remove current weight from further consideration
        end
    end
end
W0 = W0+W0.';

rpos = corrcoef(sum( W.*(W>0)),sum( W0.*(W0>0)));
rneg = corrcoef(sum(-W.*(W<0)),sum(-W0.*(W0<0)));
R = [rpos(2) rneg(2)];

% Create the new BU graph
rW = W0;
end