function rA = randomize_bct_edit(A, type, wei_freq)
% RANDOMIZE_BCT_EDIT randomizes a matrix
%
% rA = RANDOMIZE_BCT_EDIT( A, type, wei_freq) randomizes the matrix A while
%   preserving the in-and out-degree.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%   WEI_FREQ Frequency of weight sorting in weighted randomization
%          wei_freq must be in the range of: 0 < wei_freq <= 1
%          wei_freq=1 implies that weights are sorted at each step
%                     (default in older [<2011] versions of MATLAB)
%          wei_freq=0.1 implies that weights are sorted at each 10th step
%                   (faster, default in newer versions of MATLAB)
%
% This method performs the randomization in two steps. First it rewires the
%   graph and then, in case of a weighted graph, it reweighs it.
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/03/25
% http://braph.org/

A = remove_diagonal(A);
if Graph.is_directed(type)
    % Randomize the network
    if exist('wei_freq','var')
        rA = randomize_bct_D_edit(A, wei_freq);
    else
        rA = randomize_bct_D_edit(A);
    end
else
    % Randomize the network
    if exist('wei_freq','var')
        rA = randomize_bct_U_edit(A, wei_freq);
    else
        rA = randomize_bct_U_edit(A);
    end
end
end

