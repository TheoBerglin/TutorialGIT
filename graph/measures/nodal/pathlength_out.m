function plout = pathlength_out( A, type )
% PATHLENGTH_OUT out-path length of nodes
%
% PLOUT = PATHLENGTH_OUT(A,type) calculates the out-pathlength PLOUT 
%   of all nodes in the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-pathlength is the average shortest path length from a particular
%   node to all other nodes.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/28
% http://braph.org/

D = distance(A,type);

N = size(A,1); % Number of nodes
plout = zeros(1,N);

for u = 1:1:N
    Du = D(u,:);
    plout(u) = sum(Du)/length(nonzeros(Du));
end

end

