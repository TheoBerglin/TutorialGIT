function W0 = distribute_weights_directed(W, connections, wei_freq)
%DISTRIBUTE_WEIGHTS_DIRECTED distributes weights on a directed graph
%
% W0 = DISTRIBUTE_WEIGHTS_DIRECTED(W, CONNECTIONS, WEI_FREQ) distributes
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

Ap = W>0;                                               %positive adjacency matrix
An = W<0;                                               %negative adjacency matrix

Ap_r = connections>0; % Randomized positive adjacency matrix
An_r = connections<0; % Randomized negative adjacency matrix

n = size(W,1); %Number of nodes
W0=sparse(n,n);                                            %null model network
for s=[1 -1]
    % Grap indices of interest
    switch s                                            %switch sign (positive/negative)
        case 1
            Ainterest = W.*Ap;
            Ar_interest = Ap_r;
            Wv=sort(W(Ap));                             %sorted weights vector
        case -1
            Ainterest = -W.*An;
            Ar_interest = An_r;
            Wv=sort(-W(An));                            %sorted weights vector  
    end
    
    % Expected weights calculations
    Si=strength_in(Ainterest, Graph.WD).';                         
    So=strength_out(Ainterest, Graph.WD).';             
    [I, J]=find(Ar_interest);                           %weights indices
    Lij=n*(J-1)+I;                                      %linear indices  
    P=(So*Si.');                                        %expected weights matrix
    
    if wei_freq==1
        for m=numel(Wv):-1:1                            %iteratively explore all weights
            [~, Oind]=sort(P(Lij));                   %get indices of Lij that sort P
            r=ceil(rand*m);
            o=Oind(r);                                  %choose random index of sorted expected weight
            W0(Lij(o)) = s*Wv(r);                       %assign corresponding sorted weight at this index
            
            f = 1 - Wv(r)/So(I(o));                     %readjust expected weight probabilities for node I(o)
            P(I(o),:) = P(I(o),:)*f;                    %[1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            f = 1 - Wv(r)/Si(J(o));                     %readjust expected weight probabilities for node J(o)
            P(:,J(o)) = P(:,J(o))*f;                    %[1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
            
            So(I(o)) = So(I(o)) - Wv(r);                %readjust in-strength of node I(o)
            Si(J(o)) = Si(J(o)) - Wv(r);                %readjust out-strength of node J(o)
            Lij(o)=[];                                  %remove current index from further consideration
            I(o)=[];
            J(o)=[];
            Wv(r)=[];                                   %remove current weight from further consideration
        end
    else
        wei_period = round(1/wei_freq);                 %convert frequency to period
        for m=numel(Wv):-wei_period:1                   %iteratively explore at the given period
            [~, Oind]=sort(P(Lij));                   %get indices of Lij that sort P
            % Random indices for updating
            R=randperm(m,min(m,wei_period)).';
            O=Oind(R);                                  %choose random index of sorted expected weight
            W0(Lij(O)) = s*Wv(R);                       %assign corresponding sorted weight at this index
            
            % Update expected weights 
            WAi = accumarray(I(O),Wv(R),[n,1]);
            Iu = boolean(accumarray(I(O), 1, [n, 1]));  %faster, if non 1 or 0 value @boolean inside accumarray fails
            F = 1 - WAi(Iu)./So(Iu);                    %readjust expected weight probabilities for node I(o)
            P(Iu,:) = P(Iu,:).*F(:,ones(1,n));          %[1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            So(Iu) = So(Iu) - WAi(Iu);                  %readjust in-strength of node I(o)
            
            WAj = accumarray(J(O),Wv(R),[n,1]);
            Ju = boolean(accumarray(J(O), 1, [n, 1]));  %faster, if non 1 or 0 value @boolean inside accumarray fails
            F = 1 - WAj(Ju)./Si(Ju);                    %readjust expected weight probabilities for node J(o)
            P(:,Ju) = P(:,Ju).*F(:,ones(1,n)).';        %[1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
            Si(Ju) = Si(Ju) - WAj(Ju);                  %readjust out-strength of node J(o)
            
            % Remove indices from selection
            O=Oind(R);
            Lij(O)=[];                                  %remove current index from further consideration
            I(O)=[];
            J(O)=[];
            Wv(R)=[];                                   %remove current weight from further consideration
        end
    end
end

end

