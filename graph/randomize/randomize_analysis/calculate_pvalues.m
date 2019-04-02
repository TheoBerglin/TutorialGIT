clear all, close all, clc
%% Settings

method_1 = 'randomize_bct_D';
method_2 = 'randomize_braph_BD';
type = Graph.BD;
nodes = 10;

%% Locate & load data
current_loc = fileparts(which('compare_methods.m'));
data_path = path_append(current_loc, 'data');
addpath(data_path);
method_1_data = sprintf('data_%s.mat', method_1);
method_2_data = sprintf('data_%s.mat', method_2);

if exist(method_1_data, 'file') && exist(method_2_data, 'file')
    d1 = load(method_1_data);
    d1 = d1.data;
    nodes_list = extractfield(d1, 'nodes');
    row_idx = nodes_list == nodes;
    gt_data = d1(row_idx).node_data;
    
    d2 = load(method_2_data);
    data = d2.data;
    nodes_list = extractfield(data, 'nodes');
    row_idx = nodes_list == nodes;
    target_data = data(row_idx).node_data;
else
    disp('Data for specified function(s) doesn''t exist')
end

%% Loops n shit
dir = Graph.is_directed(type);
wei = Graph.is_weighted(type);

for i = 1:length(target_data)
    if target_data(i).directed == dir && target_data(i).weighted == wei
        dens = target_data(i).density;
        target_measures = target_data(i).measures;  
        gt_row = node_data_row(gt_data, dens, type);
        gt_measures = gt_data(gt_row).measures;
        comparison = calculate_pvalue_struct(gt_measures, target_measures);
        target_data(i).p_value_vs_gt = comparison;
        target_data(i).p_value_gt = gt_data(gt_row).p_value_self;
    end
end

%% Save data
data.node_data = target_data;
save_path = path_append(data_path, method_2_data);
save(save_path, 'data');
        

