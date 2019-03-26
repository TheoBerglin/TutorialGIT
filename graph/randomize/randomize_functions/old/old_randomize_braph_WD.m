function [rW,R] = randomize_braph_WD(W,bin_swaps,wei_freq)
% RANDOMIZE_BRAPH_WD randomizes the graph using the BRAPH algorithm
%
% [rW,R] = RANDOMIZE_BRAPH_WD(W,bin_swaps,wei_freq) randomizes the graph 
%   represented by the adjacency matrix W and returns the new weighted directed
%   graph rW and the correlation coefficients R, between strength sequences
%   of input and output connection matrices.
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
%   higher values of bin_swaps and wei_freq. Higher values of bin_swaps may
%   enable a more random binary organization, and higher values of wei_freq
%   may enable a more accurate conservation of strength sequences.
%
% Reference: "Weight-conserving characterization of complex functional brain
%             networks", M.Rubinov and O.Sporns
%             "Specificity and Stability in Topology of Protein Networks", S.Maslov
%             and K.Sneppen
%
% See also GraphWD.

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
if nnz(Ap) < (n*(n-1))  % if Ap not fully connected
    n2 = size(Ap,1);
    [i2 j2] = find(Ap);
    K2 = length(i2);
    bin_swaps = K2*bin_swaps;
    
    % maximal number of rewiring attempts per 'bin_swaps'
    maxAttempts = round(n2*K2/(n2*(n2-1)));
    % actual number of successful rewirings
    eff = 0;
    
    for bin_swaps = 1:bin_swaps
        att = 0;
        while (att<=maxAttempts)  % while not rewired
            while 1
                e1 = ceil(K2*rand);
                e2 = ceil(K2*rand);
                while (e2 == e1),
                    e2 = ceil(K2*rand);
                end
                a = i2(e1); b = j2(e1);
                c = i2(e2); d = j2(e2);
                
                if all(a ~= [c d]) && all(b ~= [c d]);
                    break  % all four vertices must be different
                end
            end
            
            % rewiring condition
            if ~(Ap(a,d) || Ap(c,b))
                Ap(a,d) = Ap(a,b); Ap(a,b) = 0;
                Ap(c,b) = Ap(c,d); Ap(c,d) = 0;
                
                j2(e1) = d;  % reassign edge indices
                j2(e2) = b;
                eff = eff+1;
                break;
            end  % rewiring condition
            att = att+1;
        end  % while not rewired
    end  % bin_swapsations
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
            Si = sum(W.*Ap,1).';  % positive in-strength
            So = sum(W.*Ap,2);  % positive out-strength
            Wv = sort(W(Ap));  % sorted weights vector
            [I, J] = find(Ap_r);  % weights indices
            Lij = n*(J-1)+I;  % linear weights indices
        case -1
            Si = sum(-W.*An,1).';  % negative in-strength
            So = sum(-W.*An,2);  % negative out-strength
            Wv = sort(-W(An));  % sorted weights vector
            [I, J] = find(An_r);  % weights indices
            Lij = n*(J-1)+I;  % linear weights indices
    end
    
    P = (So*Si.');  % expected weights matrix
    
    if wei_freq == 1
        for m = numel(Wv):-1:1  % iteratively explore all weights
            [dum, Oind] = sort(P(Lij));  % get indices of Lij that sort P
            r = ceil(rand*m);
            o = Oind(r);  % choose random index of sorted expected weight
            W0(Lij(o)) = s*Wv(r);  % assign corresponding sorted weight at this index
            
            f = 1 - Wv(r)/So(I(o));  % readjust expected weight probabilities for node I(o)
            P(I(o),:) = P(I(o),:)*f;  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            f = 1 - Wv(r)/Si(J(o));  % readjust expected weight probabilities for node J(o)
            P(:,J(o)) = P(:,J(o))*f;  % [1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
            
            So(I(o)) = So(I(o)) - Wv(r);  % readjust in-strength of node I(o)
            Si(J(o)) = Si(J(o)) - Wv(r);  % readjust out-strength of node J(o)
            Lij(o) = [];  % remove current index from further consideration
            I(o) = [];
            J(o) = [];
            Wv(r) = [];  % remove current weight from further consideration
        end
    else
        wei_period = round(1/wei_freq);  % convert frequency to period
        for m = numel(Wv):-wei_period:1  % iteratively explore at the given period
            [dum, Oind] = sort(P(Lij));  % get indices of Lij that sort P
            R = randperm(m,min(m,wei_period)).';
            
            O = Oind(R);  % choose random index of sorted expected weight
            W0(Lij(O)) = s*Wv(R);  % assign corresponding sorted weight at this index
            
            WAi = accumarray(I(O),Wv(R),[n,1]);
            Iu = any(WAi,2);
            F = 1 - WAi(Iu)./So(Iu);  % readjust expected weight probabilities for node I(o)
            P(Iu,:) = P(Iu,:).*F(:,ones(1,n));  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            So(Iu) = So(Iu) - WAi(Iu);  % readjust in-strength of node I(o)
            
            WAj = accumarray(J(O),Wv(R),[n,1]);
            Ju = any(WAj,2);
            F = 1 - WAj(Ju)./Si(Ju);  % readjust expected weight probabilities for node J(o)
            P(:,Ju) = P(:,Ju).*F(:,ones(1,n)).';  % [1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
            Si(Ju) = Si(Ju) - WAj(Ju);  % readjust out-strength of node J(o)
            
            O = Oind(R);
            Lij(O) = [];  % remove current index from further consideration
            I(O) = [];
            J(O) = [];
            Wv(R) = [];  % remove current weight from further consideration
        end
    end
end

rpos_in = corrcoef(sum( W.*(W>0),1), sum( W0.*(W0>0),1) );
rpos_ou = corrcoef(sum( W.*(W>0),2), sum( W0.*(W0>0),2) );
rneg_in = corrcoef(sum(-W.*(W<0),1), sum(-W0.*(W0<0),1) );
rneg_ou = corrcoef(sum(-W.*(W<0),2), sum(-W0.*(W0<0),2) );

R = [rpos_in(2) rpos_ou(2) rneg_in(2) rneg_ou(2)];
rW = W0;
end