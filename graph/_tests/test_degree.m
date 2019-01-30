% File to test the use of degree measure.
%
% Author: Adam Liberda & Theo Berglin
% Date: 2019/01/29
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
exp_res21 = 2*(N-1)*ones(1, N);
test_struct(3) = get_test_struct(A2, type21, exp_res21, 'Fully Connected Binary Directed');
type22 = Graph.WU;
exp_res22 = (N-1)*ones(1, N);
test_struct(4) = get_test_struct(A2, type22, exp_res22, 'Fully Connected Weighted Undirected');

%% Binary Undirected adj matrix
A3 = [1 0 1 1;
    0 1 0 1;
    1 0 1 0;
    1 1 0 1];
type3 = Graph.BU;
degree3 = [ 2 1 1 2];
test_struct(5) = get_test_struct(A3, type3, degree3, 'Binary Undirected');

%% Binary Directed adj matrix
A4 = [1 1 0 0 0;
    1 1 0 1 1;
    0 0 1 1 1;
    1 0 1 1 0;
    0 0 0 1 1];
type4 = Graph.BD;
degree4 = [3 4 3 5 3];
test_struct(6) = get_test_struct(A4, type4, degree4, 'Binary Directed');

%% Negative Weighted Undirected adj matrix
A5 = [1 0 -2 -4;
    0 1 0 5;
    -2 0 1 0;
    -4 5 0 1];
type5 = Graph.WUN;
degree5 = [ 2 1 1 2];
test_struct(7) = get_test_struct(A5, type5, degree5, 'Negative Weigthed Undirected');

%% Negative Weighted Undirected adj matrix
A6 = [-1 4 0 0 0;
    2 -3 0 3.2 -1.4;
    0 0 1.8 -1.7 -3.4;
    -4.2 0 -2 1 0;
    0 0 0 3.1 -0.4];
type6 = Graph.WDN;
degree6 = [3 4 3 5 3];
test_struct(8) = get_test_struct(A6, type6, degree6, 'Negative Weighted Directed');

%% Perform tests
disp('Running tests for degree calculations')
for i=1:length(test_struct)
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    exp_result = test_struct(i).exp_result;
    name = test_struct(i).name;
    
    deg = degree(connectivity_matrix, type);
    if isequal(deg, exp_result)
        fprintf('%s - passed\n', name)
    else
        fprintf('%s - failed\n', name)
    end
end

