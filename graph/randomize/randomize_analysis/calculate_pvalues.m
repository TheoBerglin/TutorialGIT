clear all, close all, clc
%% Settings
methods_gt = {'randomize_bct_D' 'randomize_bct_U'};
methods_target = {'randomize_braph_BD' 'randomize_braph_BU'};
types = {Graph.BD Graph.BU};
nodes = [10 50 100];

%% Locate method data
current_loc = fileparts(which('calculate_pvalues.m'));
data_path = path_append(current_loc, 'data');
addpath(data_path);

%% Method loop
for i = 1:length(methods_gt)
    method_gt = methods_gt{i};
    method_target = methods_target{i};
    type = types{i};
    fprintf('Running for method: %s\n', method_target)
    
    %% Load data
    method_gt_data = sprintf('data_%s.mat', method_gt);
    method_target_data = sprintf('data_%s.mat', method_target);
    if exist(method_gt_data, 'file')
        d1 = load(method_gt_data);
        d1 = d1.data;
    else
        error('Data for %s doesn''t exist', method_gt)
    end
    
    if exist(method_target_data, 'file')
        d2 = load(method_target_data);
        data = d2.data;
    else
        error('Data for %s doesn''t exist', method_target_data)
    end
    
    %% Loop through nodes
    for j = 1:length(nodes)
        node = nodes(j);
        fprintf('Running for nodes: %d\n', node)
        
        %% Get data
        nodes_list = extractfield(d1, 'nodes');
        row_idx = nodes_list == node;
        if any(row_idx)  % if data exists for node
            gt_data = d1(row_idx).node_data;
        else
            fprintf('No data for function: %s, nodes: %d\n', method_gt, node)
        end
        
        nodes_list = extractfield(data, 'nodes');
        row_idx = nodes_list == node;
        if any(row_idx)  % if data exists for node
            target_data = data(row_idx).node_data;
        else
            target_data = [];
            fprintf('No data for function: %s, nodes: %d\n', method_target, node)
        end
        
        %% Calculate p_values
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
                if node == 10
                    target_data(i).p_value_gt = gt_data(gt_row).pValues;
                else
                    target_data(i).p_value_gt = gt_data(gt_row).p_value_self;
                end
            end
        end
        
        if any(row_idx)  % if data exists for node
            data(row_idx).node_data = target_data;
            fprintf('Finished with nodes: %d\n', node)
        else
            fprintf('Finished incorrectly with nodes: %d\n', node)

        end
    end
    
    %% Save data
    save_path = path_append(data_path, method_target_data);
    save(save_path, 'data');
    
    fprintf('Finished with method: %s\n', method_target)
    disp('---------------------------------')
    
end


