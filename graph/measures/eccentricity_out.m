function eccout = eccentricity_out( A, type )
% ECCENTRICITY_OUT out-eccentricity of nodes
%
% ECCOUT = ECCENTRICITY_OUT(A,type) calculates the out-eccentricity ECCOUT 
%   of all nodes in the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights

% The out-eccentricity of a node is the maximal outgoing shortest path
% length from that particular node. The eccentricity of disconnected nodes
% is set to NaN.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/01
% http://braph.org/

D = distance(A, type);
D = replace_diagonal(D,Inf);

eccout = max(D.*(D~=Inf),[],2)';  % out-eccentricy = max of distance along row

end

