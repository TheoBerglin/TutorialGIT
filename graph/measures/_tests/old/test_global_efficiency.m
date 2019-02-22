% File to test the use of global efficiency measure.
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/07
% http://braph.org/

close all, clear all, clc

%% Initializations
N = 5; % number of nodes

%% Diagonal adjacency matrix
A1 = eye(N);
type11 = Graph.BD;
exp_res1 = zeros(1, N);
test_struct(1) = get_test_struct(A1, type11, exp_res1, 'Diagonal matrix Binary Directed');
type12 = Graph.WU;
test_struct(2) = get_test_struct(A1, type12, exp_res1, 'Diagonal matrix Weighted Undirected');

%% Fully connected adj matrix
A2 = ones(N);
type21 = Graph.BD;
exp_res2 = ones(1, N);
test_struct(3) = get_test_struct(A2, type21, exp_res2, 'Fully Connected Binary Directed');
type22 = Graph.WU;
test_struct(4) = get_test_struct(A2, type22, exp_res2, 'Fully Connected Weighted Undirected');

%% Binary Undirected adj matrix
A3 = [0 0 0 1 0;
    0 0 1 0 1;
    0 1 0 1 0;
    1 0 1 0 1;
    0 1 0 1 0];
type3 = Graph.BU;
exp_res3 = [7/12 17/24 3/4 7/8 3/4];
test_struct(5) = get_test_struct(A3, type3, exp_res3, 'Binary Undirected');

%% Binary Directed adj matrix
A4 = [1 1 0 0 0;
    1 1 0 1 1;
    0 0 1 1 1;
    1 0 1 1 0;
    0 0 0 1 1];
type4 = Graph.BD;
exp_res4 = [2/3 17/24 31/48 13/16 2/3];
test_struct(6) = get_test_struct(A4, type4, exp_res4, 'Binary Directed');

%% Weighted Directed adj matrix
A5 = [0 1/2 0 0 0;
    1/5 0 0 1/3 2;
    0 0 0 3/5 0;
    1 0 4/5 0 0;
    0 0 0 1/5 0];
type5 = Graph.WD;
exp_res5 = [1041/2729 228/457 728/2127 197/420 685/1552];
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weigthed Directed');

%% Negative Weighted Undirected adj matrix
A6 = [-1 4 0 0 0;
    2 -3 0 3.2 -1.4;
    0 0 1.8 -1.7 -3.4;
    -4.2 0 -2 1 0;
    0 0 0 3.1 -0.4];
type6 = Graph.WDN;
exp_res6 = inf(5);
test_struct(8) = get_test_struct(A6, type6, exp_res6, 'Negative Weighted Undirected');

%% Perform tests
disp('Running tests for global efficiency calculations')
tol = 1e-6;
for i=1:length(test_struct)
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    exp_result = test_struct(i).exp_result;
    name = test_struct(i).name;
    
    try
        ge = global_efficiency(connectivity_matrix, type);
    catch MException
        if isequal(MException.message, 'Negative weights, not implemented')
            ge = exp_result;
        end
    end
    
    if isequal(ge, exp_result) || all(all(abs(ge - exp_result) < tol))
        fprintf('%s - passed\n', name)
    else
        fprintf('%s - failed\n', name)
    end
end