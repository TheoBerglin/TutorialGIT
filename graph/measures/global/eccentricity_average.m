function res = eccentricity_average( A, type)
% ECCENTRICITY_AVERAGE average of the eccentricity of nodes
%
% RES = ECCENTRICITY_AVERAGE(A,type) calculates the average of the eccentricity of
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
% Date: 2019/03/01
% http://braph.org/
ecc = eccentricity(A, type);
res = mean(ecc(~isnan(ecc)));
