function [ passed, details ] = test_assortativity_in_out(  )
%TEST_ASSORTATIVITY_IN_OUT test of assortative in out measure
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/11
% http://braph.org/

%% Initializations
test_func = 'assortativity_in_out';
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
exp_res3 = (2-100/49)/(16/7-100/49);
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
exp_res5 = -0.4;
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
exp_res7 = (13/7-(4/7)^2)/(50/7-(4/7)^2);
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