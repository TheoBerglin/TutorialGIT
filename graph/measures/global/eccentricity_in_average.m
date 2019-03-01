function res = eccentricity_in_average( A, type)
% ECCENTRICITY_IN_AVERAGE average of the in-eccentricity of nodes
%
% RES = ECCENTRICITY_IN_AVERAGE(A,type) calculates the average of the 
%   in-eccentricity  of all nodes in the graph represented by the 
%   connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The in-eccentricity of a node is the maximal incoming shortest path
% length to that particular node. The eccentricity of disconnected nodes 
% is set to NaN. 
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

res = mean(eccentricity_in(A, type));
