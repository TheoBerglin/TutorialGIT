function cplin = characteristic_pathlength_in( A, type)
% CHARACTERISTIC_PATHLENGTH_IN characteristic in-pathlength of graph
%
% CPLIN = CHARACTERISTIC_PATHLENGTH_IN(A,type) calculates the characteristic in-pathlength CPLIN 
%   of the graph represented by the connectivity matrix A.
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
% The characteristic in-pathlength is the average in-pathlength
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

cplin = mean(pathlength_in(A, type));
