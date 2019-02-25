function [passed, test_struct] = test_binarize(  )
%TEST_BINARIZE test of binarize function
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/11
% http://braph.org/

%% Initializations
N = 5; % number of nodes
passed = true;
%% Binary directed
A1 = randn(N);
type1 = Graph.BD;
exp_res1 = ones(N);
test_struct(1) = get_test_struct(A1, type1, exp_res1, 'Binary directed');
g = GraphBD(A1);
if g.get_adjacency_matrix() ~= exp_res1
    test_struct(1).passed = false;
    passed = false;
else
    test_struct(1).passed = true;
end
%% Binary undirected
A2 = 3*ones(N);
type2 = Graph.BU;
exp_res2 = ones(N);
test_struct(2) = get_test_struct(A2, type2, exp_res2, 'Binary undirected 1');
g = GraphBU(A2);
if g.get_adjacency_matrix() ~= exp_res2
    test_struct(2).passed = false;
    passed = false;
else
    test_struct(2).passed = true;
end


end