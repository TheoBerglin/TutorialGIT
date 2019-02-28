function [passed, test_struct] = test_symmetrize(  )
%TEST_SYMMETRIZE test of symmetrize function
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/11
% http://braph.org/

%% Initializations
N = 5; % number of nodes
%% Binary directed
A1 = ones(N);
type1 = Graph.BD;
exp_res1 = A1;
test_struct(1) = get_test_struct(A1, type1, exp_res1, 'Binary directed 1');

A2 = triu(ones(N));
type2 = Graph.BD;
exp_res2 = A2;
test_struct(2) = get_test_struct(A2, type2, exp_res2, 'Binary directed 2');

%% Binary undirected
A1 = ones(N);
type1 = Graph.BU;
exp_res1 = A1;
test_struct(3) = get_test_struct(A1, type1, exp_res1, 'Binary undirected 1');

A2 = triu(ones(N));
type2 = Graph.BU;
exp_res2 = ones(N);
test_struct(4) = get_test_struct(A2, type2, exp_res2, 'Binary undirected 2');

%% Weighted directed
A1 = 2*ones(N);
type1 = Graph.WD;
exp_res1 = A1;
test_struct(5) = get_test_struct(A1, type1, exp_res1, 'Weighted directed 1');

A2 = triu(3*ones(N));
type2 = Graph.WD;
exp_res2 = A2;
test_struct(6) = get_test_struct(A2, type2, exp_res2, 'Weighted directed 2');

%% Weighted undirected
A1 = 2*ones(N);
type1 = Graph.WU;
exp_res1 = A1;
test_struct(7) = get_test_struct(A1, type1, exp_res1, 'Weighted undirected 1');

A2 = triu(2*ones(N));
type2 = Graph.WU;
exp_res2 = ones(N)+eye(N);
test_struct(8) = get_test_struct(A2, type2, exp_res2, 'Weighted undirected 2');

%% run test
n_tests = length(test_struct);
passed = true;
tol = 1e-6;
for i = 1:n_tests
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    g = [];
    exp_result = test_struct(i).exp_result;
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
                res = exp_result;
            end
            res = exp_result-1;
        end
    else
        res = exp_result;
    end
    
    if isequaln(res, exp_result) || all(all(abs(res - exp_result) < tol))
        test_struct(i).passed = true;
    else
        passed = false;
    end   
    
end
end