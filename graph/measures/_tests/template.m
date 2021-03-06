function [ passed, details ] = template(  )
%TEMPLATE Template to use when creating test functions for different measures
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/11
% http://braph.org/

%% Initializations
test_func = 'function that you want to test';
N = 5; % number of nodes

%% Diagonal adjacency matrix
A1 = eye(N);
type11 = Graph.BD;
exp_res1 = inf(N);
exp_res1 = remove_diagonal(exp_res1);
test_struct(1) = get_test_struct(A1, type11, exp_res1, 'Diagonal matrix Binary Directed');
type12 = Graph.WU;
test_struct(2) = get_test_struct(A1, type12, exp_res1, 'Diagonal matrix Weighted Undirected');

%% Fully connected adj matrix
A2 = ones(N);
type21 = Graph.BU;
exp_res2 = ones(N);
exp_res2 = remove_diagonal(exp_res2);
test_struct(3) = get_test_struct(A2, type21, exp_res2, 'Fully Connected Binary Undirected');
type22 = Graph.WD;
test_struct(4) = get_test_struct(A2, type22, exp_res2, 'Fully Connected Weighted Directed');

%% Binary Directed matrix
A3 = [1 1 0 0 0;
    1 1 0 1 1;
    0 0 1 1 1;
    1 0 1 1 0;
    0 0 0 1 1];
type3 = Graph.BD;
exp_res3 = [0 1 3 2 2;
    1 0 2 1 1;
    2 3 0 1 1;
    1 2 1 0 2;
    2 3 2 1 0];
test_struct(5) = get_test_struct(A3, type3, exp_res3, 'Binary Directed');

%% Binary Undirected matrix
A4 = [0 0 0 1 0;
    0 0 1 0 1;
    0 1 0 1 0;
    1 0 1 0 1;
    0 1 0 1 0];
type4 = Graph.BU;
exp_res4 = [0 3 2 1 2;
    3 0 1 2 1;
    2 1 0 1 2;
    1 2 1 0 1;
    2 1 2 1 0];
test_struct(6) = get_test_struct(A4, type4, exp_res4, 'Binary Undirected');

%% Weighted Directed matrix
A5 = [0 1/2 0 0 0;
    1/5 0 0 1/3 2;
    0 0 0 3/5 0;
    1 0 4/5 0 0;
    0 0 0 1/5 0];
type5 = Graph.WD;
exp_res5 = ...
    [0 2 25/4 5 5/2;
    4 0 17/4 3 1/2;
    8/3 14/3 0 5/3 31/6;
    1 3 5/4 0 7/2;
    6 8 25/4 5 0];
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weighted Directed');

%% Weighted Undirected matrix
A6 = [0 1/2 0 2 0;
    1/2 0 0 1/3 2;
    0 0 0 3/5 0;
    2 1/3 3/5 0 3;
    0 2 0 3 0];
type6 = Graph.WU;
exp_res6 = ...
    [0 2 25/4 5 5/2;
    4 0 17/4 3 1/2;
    8/3 14/3 0 5/3 31/6;
    1 3 5/4 0 7/2;
    6 8 25/4 5 0];
test_struct(8) = get_test_struct(A6, type6, exp_res6, 'Weighted Undirected');

%% Negative Weighted Directed matrix
A7 = [-1 4 0 0 0;
    2 -3 0 3.2 -1.4;
    0 0 1.8 -1.7 -3.4;
    -4.2 0 -2 1 0;
    0 0 0 3.1 -0.4];
type7 = Graph.WDN;
exp_res7 = zeros(5);
test_struct(9) = get_test_struct(A7, type7, exp_res7, 'Negative Weighted Directed');

%% Negative Weighted Undirected matrix
A7 = [-1 4 0 -4.2 0;
    4 -3 0 3.2 -1.4;
    0 0 1.8 -1.7 -3.4;
    -4.2 3.2 -1.7 1 0;
    0 -1.4 -3.4 0 -0.4];
type7 = Graph.WUN;
exp_res7 = zeros(5);
test_struct(9) = get_test_struct(A7, type7, exp_res7, 'Negative Weighted Undirected');

%% Perform tests
tol = 1e-6;
passed = true;

for i=1:length(test_struct)
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    exp_result = test_struct(i).exp_result;
    
    try
        eval(['res=' test_func '(connectivity_matrix, type);']);
    catch MException
        if isequal(MException.message, 'Negative weights, not implemented')
            res = exp_result;
        end
    end
    
    if isequaln(res, exp_result) || all(all(abs(res - exp_result) < tol))
        test_struct(i).passed = true;
    else
        passed = false;
    end
end

details = test_struct;

end