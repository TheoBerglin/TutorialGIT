function cpl = characteristic_pathlength( A, type)
% CHARACTERISTIC_PATHLENGTH characteristic path length of graph
%
% CPL = CHARACTERISTIC_PATHLENGTH(A,type) calculates characteristic 
%   pathlength CPL of the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The pathlength of a node is the average of the in-pathlength and
%   out-pathlength of that node.
%
% The characteristic pathlength is the average of the pathlength
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

cpl = mean(pathlength(A, type));
