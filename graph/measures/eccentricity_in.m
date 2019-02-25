function eccin = eccentricity_in( A, type )
% ECCENTRICITY_IN in-eccentricity of nodes
%
% ECCIN = ECCENTRICITY_IN(A,type) calculates the in-eccentricity ECCIN of
%   all nodes in the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The in-eccentricity of a node is the maximal incoming shortest path
% length to that particular node. The eccentricity of disconnected nodes is
% set to NaN. 
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/29
% http://braph.org/

D = distance(A, type);
D = replace_diagonal(D,Inf);

eccin = max(D.*(D~=Inf),[],1);  % in-eccentricy = max of distance along column

end

