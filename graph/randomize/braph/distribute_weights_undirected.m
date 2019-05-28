function W0 = distribute_weights_undirected(W, connections, wei_freq)
%DISTRIBUTE_WEIGHTS_UNDIRECTED distributes weights on an undirected graph
%
% W0 = DISTRIBUTE_WEIGHTS_UNDIRECTED(W, CONNECTIONS, WEI_FREQ) distributes
% the original weights W on to the new connection matrix CONNECTIONS.
% WEI_FREQ Frequency of weight sorting in weighted randomization
%          wei_freq must be in the range of: 0 < wei_freq <= 1
%          wei_freq=1 implies that weights are sorted at each step
%                     (default in older [<2011] versions of MATLAB)
%          wei_freq=0.1 implies that weights are sorted at each 10th step
%                   (faster, default in newer versions of MATLAB)
% WEI_FREQ has to be in the range >0 and <=1
%
% Randomization may be better (and execution time will be slower) for
%   higher values of wei_freq. Higher values values of wei_freq
%   may enable a more accurate conservation of strength sequences.
%
% CONNECTIONS and W have to be symmetric, ie represent undirected graphs.
%
% Reference: Rubinov and Sporns (2011) Neuroimage 56:2068-79
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/20
% http://braph.org/

% wei_freq checks
if ~exist('wei_freq','var')
    if nargin('randperm')==1
        wei_freq=1;
    else
        wei_freq=0.1;
    end
end

if wei_freq<=0 || wei_freq>1
    error('wei_freq must be in the range of: 0 < wei_freq <= 1.')
end
if wei_freq && wei_freq<1 && nargin('randperm')==1
    warning('wei_freq may only equal 1 in older (<2011) versions of MATLAB.')
    wei_freq=1;
end

% precautionary
W = remove_diagonal(W);
connections = remove_diagonal(connections);

Ap = W>0;                                                   %positive adjacency matrix
An = W<0;                                                   %negative adjacency matrix

Ap_r = connections>0; % Randomized positive adjacency matrix
An_r = connections<0; % Randomized positive adjacency matrix
n = size(W, 1); % number of nodes
W0=zeros(n);                                                %null model network
for s=[1 -1]
    switch s                                                %switch sign (positive/negative)
        case 1
            S=strength_out(W.*Ap, Graph.WU).';                                 %positive strength
            Wv=sort(W(triu(Ap)));                           %sorted weights vector
            [I,J]=find(triu(Ap_r));                         %weights indices
            Lij=n*(J-1)+I;                                  %linear weights indices
        case -1
            S=strength_out(-W.*An, Graph.WU).';                                %negative strength
            Wv=sort(-W(triu(An)));                          %sorted weights vector
            [I,J]=find(triu(An_r));                         %weights indices
            Lij=n*(J-1)+I;                                  %linear weights indices
    end
    
    P=(S*S.');                                              %expected weights matrix
    
    if wei_freq==1
        for m=numel(Wv):-1:1                                %iteratively explore all weights
            [~,Oind]=sort(P(Lij));                        %get indices of Lij that sort P
            r=ceil(rand*m);
            o=Oind(r);                                      %choose random index of sorted expected weight
            W0(Lij(o)) = s*Wv(r);                           %assign corresponding sorted weight at this index
            
            f = 1 - Wv(r)/S(I(o));                          %readjust expected weight probabilities for node I(o)
            P(I(o),:) = P(I(o),:)*f;                        %[1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            P(:,I(o)) = P(:,I(o))*f;
            f = 1 - Wv(r)/S(J(o));                          %readjust expected weight probabilities for node J(o)
            P(J(o),:) = P(J(o),:)*f;                        %[1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
            P(:,J(o)) = P(:,J(o))*f;
            
            S([I(o) J(o)]) = S([I(o) J(o)])-Wv(r);          %readjust strengths of nodes I(o) and J(o)
            Lij(o)=[];                                      %remove current index from further consideration
            I(o)=[];
            J(o)=[];
            Wv(r)=[];                                       %remove current weight from further consideration
        end
    else
        wei_period = round(1/wei_freq);                     %convert frequency to period
        for m=numel(Wv):-wei_period:1                       %iteratively explore at the given period
            [~,Oind]=sort(P(Lij));                          %get indices of Lij that sort P
            % Random indices for selection
            R=randperm(m,min(m,wei_period)).';
            O = Oind(R);
            W0(Lij(O)) = s*Wv(R);                           %assign corresponding sorted weight at this index
            
            % Update expected weights
            WA = accumarray([I(O);J(O)],Wv([R;R]),[n,1]);   %cumulative weight
            IJu = boolean(accumarray([I(O);J(O)], 1, [n, 1])); % faster
            F = 1-WA(IJu)./S(IJu);
            F = F(:,ones(1,n));                             %readjust expected weight probabilities for node I(o)
            P(IJu,:) = P(IJu,:).*F;                         %[1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            P(:,IJu) = P(:,IJu).*F.';
            S(IJu) = S(IJu)-WA(IJu);                      	%re-adjust strengths of nodes I(o) and J(o)
            
            % Remove indices from selection
            O=Oind(R);
            Lij(O)=[];                                      %remove current index from further consideration
            I(O)=[];
            J(O)=[];
            Wv(R)=[];                                       %remove current weight from further consideration
        end
    end
end
W0=W0+W0.';
end

