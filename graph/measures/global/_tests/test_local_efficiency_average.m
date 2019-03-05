function [test_struct, test_func] = test_local_efficiency_average(  )
%TEST_LOCAL_EFFICIENCY_AVERAGE Test suite for the average of the local efficiency measure
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/22
% http://braph.org/

%% Initializations
test_func = 'local_efficiency_average';
N = 5; % number of nodes

%% Diagonal adjacency matrix
A1 = eye(N);
type11 = Graph.BU;
exp_res1 = 0;
test_struct(1) = get_test_struct(A1, type11, exp_res1, 'Diagonal matrix Binary Unirected');
type12 = Graph.WU;
test_struct(2) = get_test_struct(A1, type12, exp_res1, 'Diagonal matrix Weighted Undirected');

%% Fully connected adj matrix
A2 = ones(N);
type21 = Graph.BD;
exp_res2 = 1;
test_struct(3) = get_test_struct(A2, type21, exp_res2, 'Fully Connected Binary Directed');
type22 = Graph.WD;
test_struct(4) = get_test_struct(A2, type22, exp_res2, 'Fully Connected Weighted Directed');

%% Binary Directed adj matrix
A3 = [1 1 0 0 0;
    1 1 0 1 1;
    0 0 1 1 1;
    1 0 1 1 0;
    0 0 0 1 1];
type3 = Graph.BD;
exp_res3 = 0.457777777777778;
test_struct(5) = get_test_struct(A3, type3, exp_res3, 'Binary Directed');

%% Binary Undirected adj matrix
A4 = [0 0 0 1 0;
    0 0 1 0 1;
    0 1 0 1 0;
    1 0 1 0 1;
    0 1 0 1 0];
type4 = Graph.BU;
exp_res4 = 0;
test_struct(6) = get_test_struct(A4, type4, exp_res4, 'Binary Undirected');

%% Weighted Directed adj matrix
A5 = [8 1/2 1 1/4 0;
    1/5 0 0 1/3 2;
    0 0 0 3/5 0;
    1 0 4/5 0 0;
    0 0 0 1/5 0];
type5 = Graph.WD;
exp_res5 = 0.464003005453497;
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weigthed Directed');

%% Weighted Undirected adj matrix
A6 = [8 1/2 0 1/4 0;
    1/2 0 0 1/3 2;
    0 0 0 3/5 0;
    1/4 1/3 3/5 0 1/5;
    0 2 0 1/5 0];
type6 = Graph.WU;
exp_res6 = 0.374147919454930;
test_struct(8) = get_test_struct(A6, type6, exp_res6, 'Weigthed Undirected');

%% Negative Weighted Directed matrix
A7 = [-1 4 0 0 0;
    2 -3 0 3.2 -1.4;
    0 0 1.8 -1.7 -3.4;
    -4.2 0 -2 1 0;
    0 0 0 3.1 -0.4];
type7 = Graph.WDN;
exp_res7 = 0;
test_struct(9) = get_test_struct(A7, type7, exp_res7, 'Negative Weighted Directed');

%% Negative Weighted Undirected matrix
A8 = [-1 4 0 -4.2 0;
    4 -3 0 3.2 -1.4;
    0 0 1.8 -1.7 -3.4;
    -4.2 3.2 -1.7 1 0;
    0 -1.4 -3.4 0 -0.4];
type8 = Graph.WUN;
exp_res8 = 0;
test_struct(10) = get_test_struct(A8, type8, exp_res8, 'Negative Weighted Undirected');

end

