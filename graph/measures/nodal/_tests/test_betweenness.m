function [test_struct, test_func] = test_betweenness(  )
%TEST_BETWEENNESS test suite of betweenness measure
%
% Author: Adam Liberda & Theo Berglin
% Date: 2019/02/25
% http://braph.org/
%% Initializations
N = 5; % number of nodes
test_func = 'betweenness';
%% Diagonal adjacency matrix
A1 = eye(N);
type11 = Graph.BD;
exp_res1 = zeros(1,N);
test_struct(1) = get_test_struct(A1, type11, exp_res1, 'Diagonal matrix Binary Directed');
type12 = Graph.WU;
test_struct(2) = get_test_struct(A1, type12, exp_res1, 'Diagonal matrix Weighted Undirected');
%% Fully connected adj matrix
A2 = ones(N);
type21 = Graph.BU;
exp_res2 = zeros(1,N);
test_struct(3) = get_test_struct(A2, type21, exp_res2, 'Fully Connected Binary Undirected');
type22 = Graph.WD;
test_struct(4) = get_test_struct(A2, type22, exp_res2, 'Fully Connected Weighted Directed');
%% Binary undirected matrix
A5 = [1 1 1 0 0;
    1 1 1 0 0;
    1 1 1 1 0;
    0 0 1 1 1;
    0 0 0 1 1];
type5 = Graph.BU;
exp_res5 = [0 0 2/3 1/2 0];
test_struct(5) = get_test_struct(A5, type5, exp_res5, 'Binary Undirected');

%% Binary directed matrix
A6 = [1 0 1 0 0;
    0 1 1 0 0;
    0 0 1 1 1;
    1 0 0 1 0;
    0 0 0 0 1];
type6 = Graph.BD;
exp_res6 = [1/6 0 1/2 1/6 0];
test_struct(6) = get_test_struct(A6, type6, exp_res6, 'Binary Directed');

%% Weighted undirected matrix- SHOULD FAIL
% Not implemented for this matrix as it has two paths that are the
% shortest path. Will open issue for how to handle this.
A41 = [1 4 0 2 0;
    4 1 3 6 0;
    0 3 1 0 0;
    2 6 0 1 1;
    0 0 0 1 1];
%type4 = Graph.WU;
%exp_res4 = [2/5 5/8 0 5/8 0];
%test_struct(4) = get_test_struct(A4, type4, exp_res4, 'Weighted Undirected 1, should fail!');
%% Weighted undirected matrix
A7 = [1 2 0 4 0;
    2 1 0 0 2;
    0 0 1 3 3;
    4 0 3 1 0;
    0 2 3 0 1];
type7 = Graph.WU;
exp_res7 = [1/6 0 1/3 1/3 1/6];
test_struct(7) = get_test_struct(A7, type7, exp_res7, 'Weighted Undirected 2');

%% Weighted directed matrix
A8 = [1 0 0 1 0;
    0 1 0 2 0;
    0 4 1 0 0;
    0 0 0 1 2;
    0 0 0 0 1];
type8 = Graph.WD;
exp_res8 = [0 2/12 0 3/12 0];
test_struct(8) = get_test_struct(A8, type8, exp_res8, 'Weighted Directed 1');
end