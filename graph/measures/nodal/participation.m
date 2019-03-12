function p = participation( A, type, Cs )
% PARTICIPATION participation coefficient of nodes
%
% P = PARTICIPATION(A, TYPE, CS) calculates the participation 
%   coefficient of a node from the graph, represented by the adjacency 
%   matrix A, in a given community. An optimized community structure CS 
%   is needed to perform the calculations.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The participation coefficient shows the node connectivity through the
%   availible communities. It is expressed by the ratio of the edges that
%   a node forms within a community to the total number of edges the node
%   forms whithin the whole graph. The edges are given as an average of the
%   in-and out-edges.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

if Graph.is_positive(type)
    n = size(A, 1);  % number of nodes
    outstr = sum(A, 2);  % (out)strength
    instr = sum(A, 1)';  % (in)strength
    Ko = mean([outstr instr], 2);  % avg of in-/outdegree
    Gc_out = (A~=0)*diag(Cs);  % neighbor community affiliation - out
    Gc_in = (A.'~=0)*diag(Cs);  % neighbor community affiliation - in
    Kc2 = zeros(n,1); 
    
    for i = 1:1:max(Cs)
        Kc_out = sum(A.*(Gc_out==i),2); % community-specific neighbors - out
        Kc_in = sum((A.').*(Gc_in==i),2); % community-specific neighbors - in
        Kc_temp = mean([Kc_out Kc_in], 2); % average in/out community-specific degrees
        Kc2 = Kc2 + Kc_temp.^2;
    end

    P = ones(n,1)-Kc2./(Ko.^2);
    P(~Ko) = 0;  % P=0 if for nodes with no (out)neighbors
    
    p = P';
    
elseif Graph.is_negative(type)
    error('Negative weights, not implemented');
end

end

