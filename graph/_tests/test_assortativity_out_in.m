function [test_struct, test_func] = test_assortativity_out_in(  )
%TEST_ASSORTATIVITY_OUT_IN test sute for the assortative out in measure
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/11
% http://braph.org/

%% Initializations
test_func = 'assortativity_out_in';
N = 5; % number of nodes

%% Diagonal adjacency matrix
A1 = eye(N);
type11 = Graph.BD;
exp_res1 = NaN;
test_struct(1) = get_test_struct(A1, type11, exp_res1, 'Diagonal matrix Binary Directed');
type12 = Graph.WU;
test_struct(2) = get_test_struct(A1, type12, exp_res1, 'Diagonal matrix Weighted Undirected');

%% Fully connected adj matrix
A2 = ones(N);
type21 = Graph.BU;
exp_res2 = NaN;
test_struct(3) = get_test_struct(A2, type21, exp_res2, 'Fully Connected Binary Undirected');
type22 = Graph.WD;
test_struct(4) = get_test_struct(A2, type22, exp_res2, 'Fully Connected Weighted Directed');

%% Binary Directed matrix
A3 = [1 1 0 0 0; 
    0 1 1 0 0;
    0 0 1 1 0;
    0 1 0 1 1;
    1 0 0 1 1];
type3 = Graph.BD;
exp_res3 = (17/7-(11/7)^2)/(19/7-(11/7)^2);
test_struct(5) = get_test_struct(A3, type3, exp_res3, 'Binary Directed');

%% Binary Undirected matrix
A4 = [1 1 0 0 1;
    1 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 1;
    1 0 0 1 0];
type4 = Graph.BU;
exp_res4 = (37/6-(15/6)^2)/(39/6-(15/6)^2);
test_struct(6) = get_test_struct(A4, type4, exp_res4, 'Binary Undirected');

%% Weighted Directed matrix
A5 = [1 2 0 0 0;
    0 1 3 0 0;
    0 0 1 1 0;
    0 2 0 1 2;
    1 0 0 2 1];
type5 = Graph.WD;
exp_res5 = (8-(20/7)^2)/(64/7-(20/7)^2);
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weighted Directed');

%% Weighted Undirected matrix
A6 = [1 2 0 0 1;
    2 1 3 2 0;
    0 3 1 1 0;
    0 2 1 1 2;
    1 0 0 2 1];
type6 = Graph.WU;
exp_res6 = (128/6-(28/6)^2)/(145/6-(28/6)^2);
test_struct(8) = get_test_struct(A6, type6, exp_res6, 'Weighted Undirected');

%% Negative Weighted Directed matrix
A7 = [1 -2 0 0 0;
    0 1 3 0 0;
    0 0 1 -1 0;
    0 2 0 1 2;
    -1 0 0 -2 1];
type7 = Graph.WDN;
exp_res7 = 32/48;
test_struct(9) = get_test_struct(A7, type7, exp_res7, 'Negative Weighted Directed');

%% Negative Weighted Undirected matrix
A8 = [1 2 0 0 -1;
    2 1 -3 2 0;
    0 -3 1 2 0;
    0 2 2 1 -2;
    -1 0 0 -2 1];
type8 = Graph.WUN;
exp_res8 = (-9/6-(3/12)^2)/(18.5/6-(3/12)^2);
test_struct(10) = get_test_struct(A8, type8, exp_res8, 'Negative Weighted Undirected');

end