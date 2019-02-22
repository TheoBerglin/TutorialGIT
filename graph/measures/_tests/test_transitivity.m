function [test_struct, test_func] = test_transitivity(  )
%TEST_TRANSITIVITY Test suite for the transitivity measure
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/22
% http://braph.org/

%% Initializations
test_func = 'transitivity';
N = 5; % number of nodes

%% Diagonal matrix
A1 = eye(N);
exp_res1 = 0;
type11 = Graph.BD;
test_struct(1) = get_test_struct(A1, type11, exp_res1, 'Diagonal matrix Binary Directed');
type12 = Graph.WU;
test_struct(2) = get_test_struct(A1, type12, exp_res1, 'Diagonal matrix Weighted Undirected');

%% Fully connected adj matrix
A2 = ones(N);
type21 = Graph.BU;
exp_res2 = 1;
test_struct(3) = get_test_struct(A2, type21, exp_res2, 'Fully Connected Binary Undirected');
type22 = Graph.WD;
test_struct(4) = get_test_struct(0.5*A2, type22, exp_res2, 'Fully Connected Weighted Directed');

%% Binary Directed matrix
A3 = [1 1 0 0 0 0 1;
    0 1 1 0 0 0 1;
    0 0 1 1 0 0 0;
    0 0 0 1 0 0 1;
    0 0 0 1 1 0 0;
    1 0 0 0 1 1 0;
    0 0 1 0 1 1 1];
exp_res3 = sum([1 0 1 2 1 1 3])/21;
type3 = Graph.BD;
test_struct(5) = get_test_struct(A3, type3, exp_res3, 'Binary Directed');


%% Binary Undirected matrix
A4 = [1 1 0 0 1;
    1 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 1;
    1 0 0 1 1];
exp_res4 = sum([0 1 1 1 0])/9;
type4 = Graph.BU;
test_struct(6) = get_test_struct(A4, type4, exp_res4, 'Binary Undirected');

%% Weighted Directed
A5 = [1 1/3 0 0 0;
    0 1 1 0 0;
    0 0 1 1/3 0;
    0 1/2 0 1 0;
    1/2 0 0 1/2 1];
exp_res5 = sum([0 (1/6)^(1/3) (1/6)^(1/3) (1/6)^(1/3) 0])/(2*sqrt(1/6)+1/2+2*sqrt(1/3)+1/sqrt(2));
type5 = Graph.WD;
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weighted Directed');


%% Weighted Undirected
A6 = [1 1/3 0 0 1/2;
    1/3 1 1 1/2 0;
    0 1 1 1/3 0;
    0 1/2 1/3 1 1/2;
    1/2 0 0 1/2 1];
exp_res6 = 3*(1/6)^(1/3)/(1+4*sqrt(1/6)+2*sqrt(1/3)+sqrt(1/2));
type6 = Graph.WU;
test_struct(8) = get_test_struct(A6, type6, exp_res6, 'Weighted Undirected');

%% Negative Weighted Directed
A7 = [1 1/3 0 0 0;
    0 1 -1 0 0;
    0 0 1 1/3 0;
    0 1/2 0 1 0;
    1/2 0 0 1/2 1];
exp_res7 = sum([0 -(1/6^(1/3)) -(1/6^(1/3)) -(1/6^(1/3)) 0])/(2*1/sqrt(6)+1/2-2/sqrt(3)-1/sqrt(2));
type7 = Graph.WDN;
test_struct(9) = get_test_struct(A7, type7, exp_res7, 'Negative Weighted Directed');


%% Negative weighted undirected
A8 = [1 1/3 0 0 1/2;
    1/3 1 -1 1/2 0;
    0 -1 1 1/3 0;
    0 1/2 1/3 1 1/2;
    1/2 0 0 1/2 1];
exp_res8 = sum([0 -(1/6)^(1/3) -(1/6)^(1/3) -(1/6)^(1/3) 0])/(1+4*1/sqrt(6)-2/sqrt(3)-1/sqrt(2));
type8 = Graph.WUN;
test_struct(10) = get_test_struct(A8, type8, exp_res8, 'Negative Weighted Undirected');

end
