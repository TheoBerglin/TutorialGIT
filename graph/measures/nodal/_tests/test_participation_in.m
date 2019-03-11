function [test_struct, test_func] = test_participation_in(  )
%TEST_PARTICIPATION_IN test of in-participation measure
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/20
% http://braph.org/

%% Initializations
test_func = 'participation_in';
N = 5; % number of nodes

%% Diagonal adjacency matrix
A1 = eye(N);
type11 = Graph.BD;
g11 = GraphBD(A1);
struc11 = g11.get_community_structure();
exp_res1 = zeros(1, N);
test_struct(1) = get_test_struct(A1, type11, exp_res1, 'Diagonal matrix Binary Directed', 'community_structure', struc11);
type12 = Graph.WU;
g12 = GraphWU(A1);
struc12 = g12.get_community_structure();
test_struct(2) = get_test_struct(A1, type12, exp_res1, 'Diagonal matrix Weighted Undirected', 'community_structure', struc12);

%% Fully connected adj matrix
A2 = ones(N);
type21 = Graph.BU;
g21 = GraphBU(A2);
struc21 = g21.get_community_structure();
exp_res2 = zeros(1, N);
test_struct(3) = get_test_struct(A2, type21, exp_res2, 'Fully Connected Binary Undirected', 'community_structure', struc21);
type22 = Graph.WD;
g22 = GraphWD(A2);
struc22 = g22.get_community_structure();
test_struct(4) = get_test_struct(A2, type22, exp_res2, 'Fully Connected Weighted Directed', 'community_structure', struc22);

%% Binary Directed matrix
A3 = [1 1 0 0 0; 
    0 1 1 0 0;
    0 0 1 1 0;
    0 1 0 1 1;
    1 1 1 1 1];
type3 = Graph.BD;
struc3 = [1 1 2 2 2];
exp_res3 = [1/2 1/2 4/9 0 0];
test_struct(5) = get_test_struct(A3, type3, exp_res3, 'Binary Directed', 'community_structure', struc3);

%% Binary Undirected matrix
A4 = [1 1 0 0 1;
    1 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 1;
    1 0 0 1 0];
type4 = Graph.BU;
struc4 = [2 1 1 1 2];
exp_res4 = [4/9 3/8 0 3/8 1/2];
test_struct(6) = get_test_struct(A4, type4, exp_res4, 'Binary Undirected', 'community_structure', struc4);

%% Weighted Directed matrix
A5 = [1 2 0 0 0;
    0 1 3 0 0;
    0 0 1 1 0;
    0 2 0 1 2;
    1 0 0 2 1];
type5 = Graph.WD;
g5 = GraphWD(A5);
struc5 = g5.get_community_structure();
exp_res5 = [1/2 12/25 0 3/8 0];
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weighted Directed', 'community_structure', struc5);

%% Weighted Undirected matrix
A6 = [1 2 0 0 1;
    2 1 3 2 0;
    0 3 1 1 0;
    0 2 1 1 2;
    1 0 0 2 1];
type6 = Graph.WU;
g6 = GraphWU(A6);
struc6 = g6.get_community_structure();
exp_res6 = [3/8 3/8 8/25 1/2 3/8];
test_struct(8) = get_test_struct(A6, type6, exp_res6, 'Weighted Undirected', 'community_structure', struc6);

%% Negative Weighted Directed matrix
A7 = [1 -2 0 0 0;
    0 1 3 0 0;
    0 0 1 -1 0;
    0 2 0 1 2;
    -1 0 0 -2 1];
type7 = Graph.WDN;
exp_res7 = nan(1, N);
test_struct(9) = get_test_struct(A7, type7, exp_res7, 'Negative Weighted Directed');  % structure not def for neg. weights

%% Negative Weighted Undirected matrix
A8 = [1 2 0 0 -1;
    2 1 -3 2 0;
    0 -3 1 2 0;
    0 2 2 1 -2;
    -1 0 0 -2 1];
type8 = Graph.WUN;
exp_res8 = nan(1, N);
test_struct(10) = get_test_struct(A8, type8, exp_res8, 'Negative Weighted Undirected');  % structure not def for neg. weights

end