function [passed, test_struct] = test_positivize(  )
%TEST_POSITIVIZE test of positivize function
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/25
% http://braph.org/

%% Initializations
N = 5; % number of nodes
%% Binary directed
A1 = ones(N);
type1 = Graph.BD;
exp_res1 = 'positive';
test_struct(1) = get_test_struct(A1, type1, exp_res1, 'Binary directed 1');

%% Binary undirected
A1 = ones(N);
type1 = Graph.BU;
exp_res1 = 'positive';
test_struct(2) = get_test_struct(A1, type1, exp_res1, 'Binary undirected 1');
%% Weighted directed
A2 = randn(N);
type2 = Graph.WD;
exp_res2 = 'positive';
test_struct(3) = get_test_struct(A2, type2, exp_res2, 'Weighted directed 2');

%% Weighted undirected
A1 = randn(N);
type1 = Graph.WU;
exp_res1 = 'positive';
test_struct(4) = get_test_struct(A1, type1, exp_res1, 'Weighted undirected 1');

%% run test
n_tests = length(test_struct);
passed = true;
tol = 1e-6;
for i = 1:n_tests
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
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
     if ~isempty(g)
        try
            res = g.get_adjacency_matrix();
        catch MException
            if isequal(MException.message, 'Negative weights, not implemented')
                res = -1;
            end
            res = -1;
        end
    else
        res = 1;
    end
    
    if all(all(res >= 0))
        test_struct(i).passed = true;
    else
        passed = false;
    end   
    
end
end