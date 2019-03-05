function cplout = characteristic_pathlength_out( A, type)
% CHARACTERISTIC_PATHLENGTH_OUT characteristic out-path length of graph
%
% CPLOUT = CHARACTERISTIC_PATHLENGTH_OUT(A,type) calculates the characteristic out-pathlength CPLOUT 
%   of the graph represented by the connectivity matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% The out-pathlength is the average shortest path length from a particular
%   node to all other nodes.
%
% The characteristic out-pathlength is the average out-pathlength
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/03/01
% http://braph.org/

cplout = mean(pathlength_out(A, type));
