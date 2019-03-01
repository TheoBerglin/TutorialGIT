function z = zscore(A, type, Cs)
% ZSCORE zscore of the graph A
%
% Z = ZSCORE(A, TYPE, CS) calculates the within-module degree z-score Z of the
%   graph represented by the adjacency matrix A with community structure CS.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The within-module degree z-score is a within-module version of degree
%   centrality. It measures how well a node is connected to the other
%   nodes in the same community.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/20
% http://braph.org/

if Graph.is_negative(type)
    error('Negative weights, not implemented')
end

W = A+A.';
N = size(W,1);
z = zeros(1,N);
for i = 1:1:max(Cs)
    Koi = sum(W(Cs==i,Cs==i),2);
    z(Cs==i) = (Koi-mean(Koi))./std(Koi);
end

z(isnan(z)) = 0;

end
