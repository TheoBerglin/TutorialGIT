% File to test the use of in degree measure.
%
% Author: Adam Liberda & Theo Berglin
% Date: 2019/01/29
% http://braph.org/

clear all, close all, clc

%% Diagonal matrix
A1 = eye(5);
exp_res1 = zeros(1, 5);
type1 = Graph.BD;
test_struct(1) = get_test_struct(A1, type1, exp_res1, 'Diagonal matrix');

%% Fully connected matrix
A2 = ones(5);
exp_res2 = 4*ones(1, 5);
type2 = Graph.BD;
test_struct(2) = get_test_struct(A2, type2, exp_res2, 'Fully connected matrix');

%% Binary undirected test
A3 = [1 0 1 1;
    0 1 0 1;
    1 0 1 0;
    1 1 0 1];
exp_res3 = [2 1 1 2];
type3 = Graph.BU;
test_struct(3) = get_test_struct(A3, type3, exp_res3, 'Binary Undirected');

%% Binary directed test
A4 = [1 1 0 0 0;
    1 1 0 1 1;
    0 0 1 1 1;
    1 0 1 1 0;
    0 0 0 1 1];
exp_res4 = [2 1 1 3 2];
type4 = Graph.BD;
test_struct(4) = get_test_struct(A4, type4, exp_res4, 'Binary Directed');

%% Negative values weighted undirected test
A5 = [1 0 -2 1;
    0 1 0 0.5;
    4 0 1 0;
    1 -3 0 1];
exp_res5 = [2 1 1 2];
type5 = Graph.BU;
test_struct(5) = get_test_struct(A5, type5, exp_res5, 'Negative Weighted Undirected');

%% Negative values weighted directed
A6 = [-1 1 0 0 0;
    -2 1 0 1 4;
    0 0 1 -0.5 1;
    1 0 -1 1 0;
    0 0 0 -1 1];
exp_res6 = [2 1 1 3 2];
type6 = Graph.BD;
test_struct(6) = get_test_struct(A6, type6, exp_res6, 'Negative Weighted directed');

%% Perform test
disp('Running tests for in degree calculations')
for i=1:length(test_struct)
    res = degree_in(test_struct(i).connectivity);
    exp_result = test_struct(i).exp_result;
    name = test_struct(i).name;
    if all(res == exp_result)
        fprintf('%s - Passed\n', name)
    else
        fprintf('%s - Failed\n', name)
    end
end
