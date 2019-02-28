function plin = pathlength_in( A, type )
% PATHLENGTH_IN in-pathlength of nodes
%
% PLIN = PATHLENGTH_IN(A,type) calculates the in-pathlength PLIN 
%   of all nodes in the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The in-pathlength is the average shortest pathlength from all other
%   nodes to a particular node.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/28
% http://braph.org/

D = distance(A,type);

N = size(A,1); % Number of nodes
plin = zeros(1,N);

for u = 1:1:N
    Du = D(:,u);
    plin(u) = sum(Du)/length(nonzeros(Du));
end

end

