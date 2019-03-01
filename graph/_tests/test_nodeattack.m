function [passed, test_struct] = test_nodeattack(  )
%TEST_NODEATTACK test of nodeattack function
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/28
% http://braph.org/

%% Initializations
N = 5; % number of nodes

%% Binary directed
A1 = ones(N);
type1 = Graph.BD;
nodes1 = [1 4];
exp_res1 = [0 0 0 0 0;
    0 1 1 0 1;
    0 1 1 0 1;
    0 0 0 0 0;
    0 1 1 0 1];
test_struct(1) = get_test_struct(A1, type1, exp_res1, 'Binary directed', 'nodes', nodes1);

%% Binary undirected
A1 = ones(N);
type1 = Graph.BU;
nodes1 = [];
exp_res1 = A1;
test_struct(2) = get_test_struct(A1, type1, exp_res1, 'Binary undirected', 'nodes', nodes1);

%% Weighted directed
A2 = rand(N);
type2 = Graph.WD;
nodes2 = [1 3 5];
exp_res2 = A2;
exp_res2(1,:) = 0;
exp_res2(:,1) = 0;
exp_res2(3,:) = 0;
exp_res2(:,3) = 0;
exp_res2(5,:) = 0;
exp_res2(:,5) = 0;
test_struct(3) = get_test_struct(A2, type2, exp_res2, 'Weighted directed', 'nodes', nodes2);

%% run test
n_tests = length(test_struct);
passed = true;
tol = 1e-6;
for i = 1:n_tests
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    nodes = test_struct(i).nodes;
    exp_result = test_struct(i).exp_result;
    g = [];
    if type == Graph.BD
        g = GraphBD(connectivity_matrix);
    elseif type == Graph.BU
        g = GraphBU(connectivity_matrix);
    elseif type == Graph.WU
        g = GraphWU(connectivity_matrix);
    elseif type == Graph.WD
        g = GraphWD(connectivity_matrix);
    end
    try
        res = g.nodeattack(nodes);
    catch MException
        if isequal(MException.message, 'Negative weights, not implemented')
            res = -1;
        end
        res = -1;
    end
    
    if all(all(abs(res.get_adjacency_matrix() - exp_result) < tol)) && isequal(g.get_type(), type)
        test_struct(i).passed = true;
    else
        passed = false;
    end
    
end
end