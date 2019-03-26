function rA = randomize(A, type, wei_freq)
% RANDOMIZE randomizes a matrix
%
% rA = RANDOMIZE( A, type, wei_freq) randomizes the matrix A while 
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
Ac = sign(A); %Connections only
if Graph.is_directed(type)
    % Rewire the connections
    rA = randomize_braph_BD(Ac);
    %Distribute weights if not binary
    if Graph.is_weighted(type)
        if exist('wei_freq','var')
            rA = distribute_weights_directed(A, rA, wei_freq);
        else
            rA = distribute_weights_directed(A, rA);
        end
    end
else
    % Rewire the connections
    rA = randomize_braph_BU(Ac);
    %Distribute weights if not binary
    if Graph.is_weighted(type)
        if exist('wei_freq','var')
            rA = distribute_weights_undirected(A, rA, wei_freq);
        else
            rA = distribute_weights_undirected(A, rA);
        end
    end
end
end

