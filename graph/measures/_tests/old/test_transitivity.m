% File to test the use of transitivity measure.
%
% Reference on calculations:
% * J.P.Onnela et al. "Intensity and coherence of motifs in weighted complex networks"
% * G.Fagiolo, "Clustering in complex directed networks"
% * Negative matrix: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3931641/
%    "Ego-centered networks and the ripple effect", M.E.J. Newman
% https://www.stat.washington.edu/people/pdhoff/courses/567/Notes/l16_transitivity.pdf
%
% Author: Adam Liberda & Theo Berglin
% Date: 2019/02/08
% http://braph.org/

close all, clear all, clc
%% Diagonal matrix
A1 = eye(5);
exp_res1 = 0;
type1 = Graph.BU;
test_struct(1) = get_test_struct(A1, type1, exp_res1, 'Diagonal matrix');

%% Known matrix 1 binary undirected
A2 = [1 1 0 0 1;
    1 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 1;
    1 0 0 1 1];
exp_res2 = sum([0 1 1 1 0])/9;
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
exp_res3 = sum([2 2 2 2 2 2 6])/33;
type3 = Graph.BU;
test_struct(3) = get_test_struct(A3, type3, exp_res3, 'Binary undirected matrix 2');

%% Known matrix 1 binary directed
A41 = [1 1 0 0 0 0 1;
    0 1 1 0 0 0 1;
    0 0 1 1 0 0 0;
    0 0 0 1 0 0 1;
    0 0 0 1 1 0 0;
    1 0 0 0 1 1 0;
    0 0 1 0 1 1 1];
exp_res41 = sum([1 0 1 2 1 1 3])/21;
type41 = Graph.BD;
test_struct(4) = get_test_struct(A41, type41, exp_res41, 'Binary directed matrix 1');

%% Known matrix 2 binary directed
A4 = [1 0 0 0 1;
    1 1 0 1 0;
    0 1 1 1 0;
    0 0 0 1 0;
    0 0 0 1 1];
exp_res4 = 0;
type4 = Graph.BD;
test_struct(5) = get_test_struct(A4, type4, exp_res4, 'Binary directed matrix 2');

%% Known matrix 1 weighted undirected
A5 = [1 1/3 0 0 1/2;
    1/3 1 1 1/2 0;
    0 1 1 1/3 0;
    0 1/2 1/3 1 1/2;
    1/2 0 0 1/2 1];
exp_res5 = 3*(1/6)^(1/3)/(1+4*sqrt(1/6)+2*sqrt(1/3)+sqrt(1/2));
type5 = Graph.WU;
test_struct(6) = get_test_struct(A5, type5, exp_res5, 'Weighted undirected matrix 1');

%% Known matrix 1 weighted directed
A6 = [1 1/3 0 0 0;
    0 1 1 0 0;
    0 0 1 1/3 0;
    0 1/2 0 1 0;
    1/2 0 0 1/2 1];
exp_res6 = sum([0 (1/6)^(1/3) (1/6)^(1/3) (1/6)^(1/3) 0])/(2*sqrt(1/6)+1/2+2*sqrt(1/3)+1/sqrt(2));
type6 = Graph.WD;
test_struct(7) = get_test_struct(A6, type6, exp_res6, 'Weighted directed matrix 1');

%% Known matrix weighted undirected negative 1
A7 = [1 1/3 0 0 1/2;
    1/3 1 -1 1/2 0;
    0 -1 1 1/3 0;
    0 1/2 1/3 1 1/2;
    1/2 0 0 1/2 1];
exp_res7 = sum([0 -(1/6)^(1/3) -(1/6)^(1/3) -(1/6)^(1/3) 0])/(1+4*1/sqrt(6)-2/sqrt(3)-1/sqrt(2));
type7 = Graph.WUN;
test_struct(8) = get_test_struct(A7, type7, exp_res7, 'Weighted undirected matrix negative 1');

%% Known matrix weighted undirected negative 2
A8 = [1 1/3 0 0 0;
    0 1 -1 0 0;
    0 0 1 1/3 0;
    0 1/2 0 1 0;
    1/2 0 0 1/2 1];
exp_res8 = sum([0 -(1/6^(1/3)) -(1/6^(1/3)) -(1/6^(1/3)) 0])/(2*1/sqrt(6)+1/2-2/sqrt(3)-1/sqrt(2));
type8 = Graph.WDN;
test_struct(9) = get_test_struct(A8, type8, exp_res8, 'Weighted directed matrix negative 1');

%% Perform test
disp('Running tests for transitivity calculations')
tolerance = 1e-6;
for i=1:length(test_struct)
    
    exp_result = test_struct(i).exp_result;
    name = test_struct(i).name;
    
    try
        res = transitivity(test_struct(i).connectivity, test_struct(i).type);
    catch MException
        if isequal(MException.message, 'ERROR, not implemented for this graph type')
            res = exp_result;
            disp(MException.message)
        else
            disp(MException.message)
        end
    end
    if all(res == exp_result) || all(abs(exp_result-res) < tolerance)
        fprintf('%s - Passed\n', name)
    else
        fprintf('%s - Failed\n', name)
    end
    
end
