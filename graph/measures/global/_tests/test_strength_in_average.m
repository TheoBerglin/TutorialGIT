function [test_struct, test_func] = test_strength_in_average(  )
%TEST_STRENGTH_IN_AVERAGE Test suite for the average of the in strength measure
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/28
% http://braph.org/

%% Initializations
test_func = 'strength_in_average';
N = 5; % number of nodes

%% Diagonal adjacency matrix
A1 = eye(N);
type11 = Graph.BD;
exp_res1 = mean(zeros(1,N));
test_struct(1) = get_test_struct(A1, type11, exp_res1, 'Diagonal matrix Binary Directed');
type12 = Graph.WU;
test_struct(2) = get_test_struct(A1, type12, exp_res1, 'Diagonal matrix Weighted Undirected');

%% Fully connected adj matrix
A2 = ones(N);
type21 = Graph.BU;
exp_res2 = mean(4*ones(1,N));
test_struct(3) = get_test_struct(A2, type21, exp_res2, 'Fully Connected Binary Undirected');
type22 = Graph.WD;
test_struct(4) = get_test_struct(0.5*A2, type22, 0.5*exp_res2, 'Fully Connected Weighted Directed');

%% Binary Directed matrix
A3 = [1 1 0 0 0;
      1 1 0 1 1;
    0 0 1 1 1;
    1 0 1 1 0;
    0 0 0 1 1];
type3 = Graph.BD;
exp_res3 = mean([2 1 1 3 2]);
test_struct(5) = get_test_struct(A3, type3, exp_res3, 'Binary Directed');

%% Binary Undirected matrix
A4 = [0 0 0 1 0;
    0 0 1 0 1;
    0 1 0 1 0;
    1 0 1 0 1;
    0 1 0 1 0];
type4 = Graph.BU;
exp_res4 = mean([1 2 2 3 2]);
test_struct(6) = get_test_struct(A4, type4, exp_res4, 'Binary Undirected');

%% Weighted Directed matrix
A5 = [1 0 0 0 7;
    3 1 5 0 0;
    0 4 1 4 0;
    0 0 5 1 0;
    0 0 0 6 1];
type5 = Graph.WD;
exp_res5 = mean([3 4 10 10 7]);
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weighted Directed');

%% Weighted Undirected matrix
A6 = [1 6 0 0 7;
    6 1 5 0 0;
    0 5 1 4 0;
    0 0 4 1 6;
    7 0 0 6 1];
type6 = Graph.WU;
exp_res6 = mean([13 11 9 10 13]);
test_struct(8) = get_test_struct(A6, type6, exp_res6, 'Weighted Undirected');

%% Negative Weighted Directed matrix
A7 = [1 0 0 0 7;
    3 1 -5 0 0;
    0 4 1 -4 0;
    0 0 5 1 0;
    0 0 0 6 1];
type7 = Graph.WDN;
exp_res7 = mean([3 4 0 2 7]);
%exp_res7 = zeros(1,5);
test_struct(9) = get_test_struct(A7, type7, exp_res7, 'Negative Weighted Directed');

%% Negative Weighted Undirected matrix
A8 = [1 -6 0 0 7;
    3 1 -5 0 0;
    0 4 1 -4 0;
    0 0 5 1 -3;
    -7 0 0 6 1];
type8 = Graph.WUN;
exp_res8 = mean([-4 -2 0 2 4]);
test_struct(10) = get_test_struct(A8, type8, exp_res8, 'Negative Weighted Undirected');

end
