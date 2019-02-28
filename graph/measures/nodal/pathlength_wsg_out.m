function plout = pathlength_wsg_out( A, type )
% PATHLENGTH_WSG_OUT out-path length of nodes within subgraphs
%
% PLOUT = PATHLENGTH_WSG_OUT(A,type) calculates the out-pathlength PLOUT 
%   withing subgraphs of all nodes in the graph represented by the 
%   connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-pathlength-wsg is the average shortest path length from a particular
%   node to all other nodes. Only nodes belonging to the same subgraph
%   are taken into consideration. The out-pathlength-wsg of
%   disconnected nodes is set to NaN.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/05
% http://braph.org/

D = distance(A,type);
D = replace_diagonal(D,Inf);

N = size(A,1); % Number of nodes
plout = zeros(1,N);

for u = 1:1:N
    Du = D(u,:);
    plout(u) = sum(Du(Du~=Inf))/length(nonzeros(Du~=Inf));
end

end

