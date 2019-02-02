function ecc = eccentricity( A, type )
% ECCENTRICITY eccentricity of nodes
%
% ECC = ECCENTRICITY(A,type) calculates the eccentricity ECC of
%   all nodes in the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The eccentricity of a node is the maximum of the maximal shortest path
% length for a node. The eccentricity of disconnected nodes is set to NaN. 
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/01
% http://braph.org/

ecc = max(eccentricity_in(A, type), eccentricity_out(A, type));

end

