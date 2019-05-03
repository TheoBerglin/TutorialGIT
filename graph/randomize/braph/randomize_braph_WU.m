function Ar_reweighed = randomize_braph_WU( A )
% RANDOMIZE_BRAPH_WU Undirected random graphs with preserved weight,
%                   degree and strength distributions
%
%   This function randomizes an undirected network with positive and
%   negative weights, while preserving the degree and strength
%   distributions. 
%
%   Returns a randomization adjacency matrix AR_REWEIGHTED of the original 
%   adjacency matrix A 
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/05/03
% http://braph.org/

A = remove_diagonal(A);
A_bin = sign(A);
Ar = randomize_braph_BU(A_bin);
Ar_reweighed = distribute_weights_undirected(A, Ar);

end

