function rA = randomize_bct(A, type, bin_swaps, wei_freq)
% RANDOMIZE_BCT randomizes a matrix
%
% rA = RANDOMIZE_BCT( A, type, wei_freq) randomizes the matrix A while
%   preserving the in-and out-degree.
%   TYPE specifies the type of graph:
%   Graph.BD = Binary Directed
%   Graph.BU = Binary Undirected
%   Graph.WD = Weighted Directed
%   Graph.WU = Weighted Undirected
%   Graph.WDN = Weighted Directed with Negative weights
%   Graph.WUN = Weighted Undirected with Negative weights
%   bin_swaps,  Average number of swaps of each edge in binary randomization.
%                           bin_swap=5 is the default (each edge rewired 5 times)
%                           bin_swap=0 implies no binary randomization 
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
% Determine which function to use
if Graph.is_directed(type)
    r_function = 'randomize_bct_D_edit';
else
    
    r_function = 'randomize_bct_U_edit';
end

% Randomize the network
if exist('bin_swaps','var')
    % Randomize the network
    if exist('wei_freq','var')
        % Only wei freq as optional argument
        eval(sprintf('rA = %s(A, bin_swaps, wei_freq);', r_function))
    else
        % Only bin swaps as optional argument
        eval(sprintf('rA = %s(A, bin_swaps);', r_function))
    end
else
    % No optional argument, only adjacency matrix
    eval(sprintf('rA = %s(A);', r_function))
end

end

