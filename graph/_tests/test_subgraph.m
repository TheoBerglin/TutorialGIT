% File to test the use of subgraph function.
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/05
% http://braph.org/

close all, clear all, clc

%% Initializations
N = 5; % number of nodes

%% Random tests
A1 = eye(N);
nodes = [1 3 5];
exp_res1 = eye(3);
sg1 = subgraph(A1, nodes);


A2 = rand(10);
nodes = [1 2 5 8];
exp_res2 = A2(nodes, nodes);
sg2 = subgraph(A2, nodes);

%% Perform tests

if isequaln(sg1, exp_res1) && isequaln(sg2, exp_res2)
    fprintf('Passed\n')
else
    fprintf('Failed\n')
end
