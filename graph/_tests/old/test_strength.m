% File to test the use of strength measure.
%
% Author: Adam Liberda & Theo Berglin
% Date: 2019/01/31
% http://braph.org/

clear all, close all, clc
%% Fully connected matrix everything 0.5

A1 = 0.5*ones(5);
exp_res1 = 4*ones(1, 5);
type1 = Graph.WD;
test_struct(1) = get_test_struct(A1, type1, exp_res1, 'Fully connected weigthed directed matrix');

%% Test diagonal matrix

A2 = eye(5);
exp_res2 = zeros(1, 5);
type2 = Graph.BD;
test_struct(2) = get_test_struct(A2, type2, exp_res2, 'Diagonal matrix');

%% Test known matrix

known_1 = [1 6 0 0 7;
    3 1 5 0 0;
    0 4 1 4 0;
    0 0 5 1 3;
    7 0 0 6 1];
strength_1=[23 18 18 18 23];

known_2 = [1 -6 0 0 7;
    3 1 -5 0 0;
    0 4 1 -4 0;
    0 0 5 1 -3;
    -7 0 0 6 1];
strength_2 = [-3 -4 0 4 3];

%% Test (positive) weighted matrix no decimal

A3 = known_1;
exp_res3 = strength_1;
type3 = Graph.WD;
test_struct(3) = get_test_struct(A3, type3, exp_res3, 'Weighted directed (positive) matrix integers');

%% Test (positive) weighted matrix decimal

A4 = known_1/10;
exp_res4 = strength_1/10;
type4 = Graph.WD;
test_struct(4) = get_test_struct(A4, type4, exp_res4, 'Weighted directed (positive) matrix decimal');

%% Test (negative) weighted matrix no decimal

A5 = known_2;
exp_res5 = strength_2;
type5 = Graph.WD;
test_struct(5) = get_test_struct(A5, type5, exp_res5, 'Weighted directed negative matrix integers');

%% Test (negative) weighted matrix no decimal

A6 = known_2/10;
exp_res6 = strength_2/10;
type6 = Graph.WD;
test_struct(6) = get_test_struct(A6, type6, exp_res6, 'Weighted directed negative matrix decimal');

%% Test (negative) weighted matrix no decimal

A7 = known_2;
exp_res7 = strength_2/2;
type7 = Graph.WU;
test_struct(7) = get_test_struct(A7, type7, exp_res7, 'Weighted undirected negative matrix integers ');

%% Test (negative) weighted matrix no decimal

A8 = known_2/10;
exp_res8 = strength_2/20;
type8 = Graph.WU;
test_struct(8) = get_test_struct(A8, type8, exp_res8, 'Weighted undirected negative matrix decimal');

%% Perform test

disp('Running tests for strength in calculations')
threshold = 1e-6;
for i=1:length(test_struct)
    res = strength(test_struct(i).connectivity, test_struct(i).type);
    exp_result = test_struct(i).exp_result;
    name = test_struct(i).name;
    if all(abs(res-exp_result) < threshold)
        fprintf('%s - Passed\n', name)
    else
        fprintf('%s - Failed\n', name)
    end
end
