function unaffected = reweighing_bct_D( W )
%REWEIGHING_BCT_D Summary of this function goes here
%   Detailed explanation goes here

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

n=size(W,1);                                            %number of nodes
W(1:n+1:end)=0;                                         %clear diagonal
edges = nnz(W);
Ap = W>0;                                               %positive adjacency matrix
An = W<0;                                               %negative adjacency matrix

if nnz(Ap)<(n*(n-1))                                    %if Ap is not full
    indizes = randperm(n*n, edges);
    W_r = zeros(n);
    W_r(indizes) = 1;
    Ap_r = W_r>0;
    An_r = W_r<0;
else
    Ap_r = Ap;
    An_r = An;
end


W0=zeros(n);                                            %null model network
for s=[1 -1]
    switch s                                            %switch sign (positive/negative)
        case 1
            Si=sum(W.*Ap,1).';                          %positive in-strength
            So=sum(W.*Ap,2);                            %positive out-strength
            Wv=sort(W(Ap));                             %sorted weights vector
            [I, J]=find(Ap_r);                          %weights indices
            Lij=n*(J-1)+I;                              %linear weights indices
        case -1
            Si=sum(-W.*An,1).';                         %negative in-strength
            So=sum(-W.*An,2);                           %negative out-strength
            Wv=sort(-W(An));                            %sorted weights vector
            [I, J]=find(An_r);                          %weights indices
            Lij=n*(J-1)+I;                              %linear weights indices
    end
    
    P=(So*Si.');                                        %expected weights matrix
    
    if wei_freq==1
        for m=numel(Wv):-1:1                            %iteratively explore all weights
            [dum, Oind]=sort(P(Lij));                   %get indices of Lij that sort P
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
            [dum, Oind]=sort(P(Lij));                   %get indices of Lij that sort P
            R=randperm(m,min(m,wei_period)).';

            O=Oind(R);                                  %choose random index of sorted expected weight
            W0(Lij(O)) = s*Wv(R);                       %assign corresponding sorted weight at this index

            WAi = accumarray(I(O),Wv(R),[n,1]);
            Iu = any(WAi,2);
            F = 1 - WAi(Iu)./So(Iu);                    %readjust expected weight probabilities for node I(o)
            P(Iu,:) = P(Iu,:).*F(:,ones(1,n));          %[1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
            So(Iu) = So(Iu) - WAi(Iu);                  %readjust in-strength of node I(o)

            WAj = accumarray(J(O),Wv(R),[n,1]);
            Ju = any(WAj,2);
            F = 1 - WAj(Ju)./Si(Ju);                    %readjust expected weight probabilities for node J(o)
            P(:,Ju) = P(:,Ju).*F(:,ones(1,n)).';        %[1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
            Si(Ju) = Si(Ju) - WAj(Ju);                  %readjust out-strength of node J(o)
            
            O=Oind(R);
            Lij(O)=[];                                  %remove current index from further consideration
            I(O)=[];
            J(O)=[];
            Wv(R)=[];                                   %remove current weight from further consideration
        end
    end
end

unaffected = isequal(W0, W_r);

end

