function pout = participation_out( A, type, Cs )
% PARTICIPATION_OUT out-participation coefficient of nodes
%
% POUT = PARTICIPATION_OUT(A, TYPE, CS) calculates the out-participation 
%   coefficient of a node from the graph, represented by the adjacency 
%   matrix A, in a given community. An optimized community structure Cs 
%   is needed to perform the calculations.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-participation coefficient shows the node connectivity through the
%   availible communities. It is expressed by the ratio of the out-edges that
%   a node forms within a community to the total number of out-edges the node
%   forms whithin the whole graph.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/20
% http://braph.org/

if Graph.is_positive(type)
    n = size(A, 1);  % number of nodes
    Ko = sum(A,2);  % (out)degree/strength
    Gc = (A~=0)*diag(Cs);  % neighbor community affiliation
    Kc2 = zeros(n,1);  % community-specific neighbors
    
    for i = 1:1:max(Cs)
        Kc2 = Kc2+(sum(A.*(Gc==i),2).^2);
    end
    
    P = ones(n,1)-Kc2./(Ko.^2);
    P(~Ko) = 0;  % P=0 if for nodes with no (out)neighbors
    
    pout = P';
elseif Graph.is_negative(type)
    error('Negative weights, not implemented');
end

end

