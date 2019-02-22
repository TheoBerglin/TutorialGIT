function mu = calculate_average(func, A, type )
% CALCULATE_AVERAGE Calculates the average of a nodal value
%
% MU = CALCULATE_AVERAGE(FUNC, A, TYPE) calculates the average MU of the
%   output from the function FUNC for the graph represented by the 
%   adjacency matrix A.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/21
% http://braph.org/

f_value = feval(func, A, type);
mu = mean(f_value);

end

