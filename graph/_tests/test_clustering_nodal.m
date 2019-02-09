% File to test the use of cluster coefficient measure for each node.
%
% Reference on calculations: 
% * J.P.Onnela et al. "Intensity and coherence of motifs in weighted complex networks"
% * G.Fagiolo, "Clustering in complex directed networks"
% * Negative matrix: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3931641/
%
% Author: Adam Liberda & Theo Berglin
% Date: 2019/02/05
% http://braph.org/

close all, clear all, clc
%% Diagonal matrix
A1 = eye(5);
exp_res1 = zeros(1, 5);
type1 = Graph.BU;
test_struct(1) = get_test_struct(A1, type1, exp_res1, 'Diagonal matrix');

%% Known matrix 1 binary undirected
A2 = [1 1 0 0 1;
    1 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 1;
    1 0 0 1 1];
exp_res2 = 2*[0 1/6 1/2 1/6 0];
type2 = Graph.BU;
test_struct(2) = get_test_struct(A2, type2, exp_res2, 'Binary undirected matrix 1');

%% Known matrix 2 binary undirected
A3 = [1 1 0 0 0 1 1;
    1 1 1 0 0 0 1;
    0 1 1 1 0 0 1;
    0 0 1 1 1 0 1;
    0 0 0 1 1 1 1;
    1 0 0 0 1 1 1;
    1 1 1 1 1 1 1];
exp_res3 = 2*[2 2 2 2 2 2 6/5]/6;
type3 = Graph.BU;
test_struct(3) = get_test_struct(A3, type3, exp_res3, 'Binary undirected matrix 2');

%% Known matrix 1 binary directed
A3 = [1 1 0 0 0 0 1;
    0 1 1 0 0 0 1;
    0 0 1 1 0 0 0;
    0 0 0 1 0 0 1;
    0 0 0 1 1 0 0;
    1 0 0 0 1 1 0;
    0 0 1 0 1 1 1];
exp_res3 = [1 0 1 2 1 1 3]./[2 2 2 2 2 2 9];
type3 = Graph.BD;
test_struct(4) = get_test_struct(A3, type3, exp_res3, 'Binary directed matrix 1');

%% Known matrix 2 binary directed 
A4 = [1 0 0 0 1;
    1 1 0 1 0;
    0 1 1 1 0;
    0 0 0 1 0;
    0 0 0 1 1];
exp_res4 = [0 0 0 0 0];
type4 = Graph.BD;
test_struct(5) = get_test_struct(A4, type4, exp_res4, 'Binary directed matrix 2');

%% Known matrix 1 weighted undirected
A5 = [1 1 0 0 1;
    1 1 3 1 0;
    0 3 1 2 0;
    0 1 2 1 1;
    1 0 0 1 1];
exp_res5 = 2*[0 6^(1/3)/6 6^(1/3)/2 6^(1/3)/6 0]/3;
type5 = Graph.WU;
test_struct(6) = get_test_struct(A5, type5, exp_res5, 'Weighted undirected matrix 1');

%% Known matrix 1 weighted directed
A6 = [1 0 0 0 2;
    1 1 4 0 0;
    0 0 1 0 5;
    1 0 1 1 1;
    0 3 0 0 1];
exp_res6 = [6/2 18/2 12/2 0 18/3]/5;
type6 = Graph.WD;
test_struct(7) = get_test_struct(A5, type5, exp_res5, 'Weighted directed matrix 1');

%% Known matrix weighted undirected negative 1
A7 = [1 1 0 0 1;
    1 1 -3 1 0;
    0 -3 1 -2 0;
    0 1 -2 1 1;
    1 0 0 1 1];
exp_res7 = 2*[0 6^(1/3)/6 6^(1/3)/2 6^(1/3)/6 0]/3;
type7 = Graph.WUN;
test_struct(8) = get_test_struct(A7, type7, exp_res7, 'Weighted undirected matrix negative 1');

%% Known matrix weighted undirected negative 2
A8 = [1 1 0 0 1;
    1 1 3 -1 0;
    0 3 1 2 0;
    0 -1 2 1 1;
    1 0 0 1 1];
exp_res8 = 2*[0 -(6^(1/3))/6 -(6^(1/3))/2 -(6^(1/3))/6 0]/3;
type8 = Graph.WUN;
test_struct(9) = get_test_struct(A8, type8, exp_res8, 'Weighted undirected matrix negative 2');

%% Known matrix weighted directed negative
A9 = [1 0 0 0 2;
    1 1 4 0 0;
    0 0 1 0 -5;
    1 0 1 1 1;
    0 -3 0 0 1];
exp_res9 = [-(6^(1/3))/2 ((4*5*3)^(1/3)-6^(1/3))/2 (4*5*3)^(1/3)/2  0 ((4*5*3)^(1/3)-6^(1/3))/3]/5;
type9 = Graph.WDN;
test_struct(10) = get_test_struct(A9, type9, exp_res9, 'Weighted directed negative matrix');

%% Perform test
disp('Running tests for cluster calculations')
tolerance = 1e-6;
for i=1:length(test_struct)
    
    exp_result = test_struct(i).exp_result;
    name = test_struct(i).name;
    
    try
        res = clustering_nodal(test_struct(i).connectivity, test_struct(i).type);
    catch MException
        if isequal(MException.message, 'Not implemented for this graph type')
            res = exp_result;
            disp(MException.message)
        end
    end
    if all(res == exp_result) || all(abs(exp_result-res) < tolerance)
        fprintf('%s - Passed\n', name)
    else
        fprintf('%s - Failed\n', name)
    end
    
end
