clear all, close all, clc
type = Graph.BU;
n = 50;
n_graphs = 500;
%% Load data
load('data_randomize_bct_U.mat');
data_bct = data(2).node_data;
load('data_randomize_braph_BU.mat')
data_braph = data(2).node_data;

densities = [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3];
dir = Graph.is_directed(type);
wei = Graph.is_weighted(type);
for di = 1:length(densities)
    ass_in_in = zeros(1, n_graphs);
    ass_in_out = zeros(1, n_graphs);
    ass_out_in = zeros(1, n_graphs);
    ass_out_out = zeros(1, n_graphs);
    for i = 1:n_graphs
        A = create_matrix(densities(di)*100, n, dir, wei);
        ass_in_in(1, i) = assortativity_in_in(A, type);
        ass_in_out(1, i) = assortativity_in_out(A, type);
        ass_out_in(1, i) = assortativity_out_in(A, type);
        ass_out_out(1, i) = assortativity_out_out(A, type);
    end
    rowi_bct = node_data_row(data_bct, densities(di), type);
    rowi_braph = node_data_row(data_bct, densities(di), type);
    disp('----------------------------------------------------')
    fprintf('Running for density: %.2f\n', densities(di))
    disp('------------- BCT vs Random Graph----------------')
    printPassedTest(extractfield(data_bct(rowi_bct).measures, 'ass_in_in'), ass_in_in, 'Assortativity in in')
    printPassedTest(extractfield(data_bct(rowi_bct).measures, 'ass_out_in'), ass_out_in, 'Assortativity out in')
    printPassedTest(extractfield(data_bct(rowi_bct).measures, 'ass_in_out'), ass_in_out, 'Assortativity in out')
    printPassedTest(extractfield(data_bct(rowi_bct).measures, 'ass_out_out'), ass_out_out, 'Assortativity out out')
    disp('------------- BRAPH vs Random Graph----------------')
    printPassedTest(extractfield(data_braph(rowi_braph).measures, 'ass_in_in'), ass_in_in, 'Assortativity in in')
    printPassedTest(extractfield(data_braph(rowi_braph).measures, 'ass_out_in'), ass_out_in, 'Assortativity out in')
    printPassedTest(extractfield(data_braph(rowi_braph).measures, 'ass_in_out'), ass_in_out, 'Assortativity in out')
    printPassedTest(extractfield(data_braph(rowi_braph).measures, 'ass_out_out'), ass_out_out, 'Assortativity out out')
    disp('------------- BCT vs BRAPH----------------')
    printPassedTest(extractfield(data_bct(rowi_bct).measures, 'ass_in_in'), extractfield(data_braph(rowi_braph).measures, 'ass_in_in'), 'Assortativity in in')
    printPassedTest(extractfield(data_bct(rowi_bct).measures, 'ass_out_in'), extractfield(data_braph(rowi_braph).measures, 'ass_in_in'), 'Assortativity out in')
    printPassedTest(extractfield(data_bct(rowi_bct).measures, 'ass_in_out'), extractfield(data_braph(rowi_braph).measures, 'ass_in_in'), 'Assortativity in out')
    printPassedTest(extractfield(data_bct(rowi_bct).measures, 'ass_out_out'), extractfield(data_braph(rowi_braph).measures, 'ass_in_in'), 'Assortativity out out')
    
    disp('------------- Random Graph vs Random Graph----------------')
    printPassedTest(ass_in_in(1:n_graphs/2), ass_in_in(n_graphs/2:end), 'Assortativity in in')
    printPassedTest(ass_in_in(1:n_graphs/2), ass_out_in(n_graphs/2:end), 'Assortativity out in')
    printPassedTest(ass_in_in(1:n_graphs/2), ass_in_out(n_graphs/2:end), 'Assortativity in out')
    printPassedTest(ass_in_in(1:n_graphs/2), ass_out_out(n_graphs/2:end), 'Assortativity out out')
end

function printPassedTest(d1, d2, name)
p = permutation_test(d1, d2);
if p >=0.05
    fprintf('Passed for measure %s\n', name)
else
    fprintf('Failed for measure %s\n', name)
end
end