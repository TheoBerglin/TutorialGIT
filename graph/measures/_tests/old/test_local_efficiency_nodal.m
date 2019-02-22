% File to test the use of nodal local efficiency measure.
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/11
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
exp_res3 = zeros(1,N);
test_struct(5) = get_test_struct(A3, type3, exp_res3, 'Binary Undirected');

%% Binary Directed adj matrix
A4 = [1 1 0 0 0;
    1 1 0 1 1;
    0 0 1 1 1;
    1 0 1 1 0;
    0 0 0 1 1];
type4 = Graph.BD;
exp_res4 = [0.5000 0.4000 0.5000 0.305555555555556 0.583333333333333];
test_struct(6) = get_test_struct(A4, type4, exp_res4, 'Binary Directed');

%% Weighted Directed adj matrix
A5 = [8 1/2 1 1/4 0;
    1/5 0 0 1/3 2;
    0 0 0 3/5 0;
    1 0 4/5 0 0;
    0 0 0 1/5 0];
type5 = Graph.WD;
exp_res5 = [0.845710576140894 0.270968503265641 0.721970816064546 0.225928654331886 0.255436477464518];
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weigthed Directed');

%% Weighted Undirected adj matrix
A6 = [8 1/2 0 1/4 0;
    1/2 0 0 1/3 2;
    0 0 0 3/5 0;
    1/4 1/3 3/5 0 1/5;
    0 2 0 1/5 0];
type6 = Graph.WU;
exp_res6 = [0.800100737684764 0.386941650012847 0 0.172824254648004 0.510872954929036
];
test_struct(8) = get_test_struct(A6, type6, exp_res6, 'Weigthed Undirected');

%% Negative Weighted Undirected adj matrix
A7 = [-1 4 0 0 0;
    2 -3 0 3.2 -1.4;
    0 0 1.8 -1.7 -3.4;
    -4.2 0 -2 1 0;
    0 0 0 3.1 -0.4];
type7 = Graph.WDN;
exp_res7 = inf(5);
test_struct(9) = get_test_struct(A7, type7, exp_res7, 'Negative Weighted Undirected');

%% Perform tests
disp('Running tests for nodal local efficiency calculations')
tol = 1e-6;
for i=1:length(test_struct)
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    exp_result = test_struct(i).exp_result;
    name = test_struct(i).name;
    
    try
        le = local_efficiency_nodal(connectivity_matrix, type);
    catch MException
        if isequal(MException.message, 'Negative weights, not implemented')
            le = exp_result;
        end
    end
    
    if isequal(le, exp_result) || all(all(abs(le - exp_result) < tol))
        fprintf('%s - passed\n', name)
    else
        fprintf('%s - failed\n', name)
    end
end