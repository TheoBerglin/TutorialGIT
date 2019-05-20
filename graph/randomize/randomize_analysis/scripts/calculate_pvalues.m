clear all, close all, clc
%% Settings
methods_gt = {'randomize_bct_D_wei' 'randomize_bct_D_wei' 'randomize_bct_U_wei' 'randomize_bct_U_wei'};
methods_target = {'randomize_braph_WD' 'randomize_bct_D_edit_wei' 'randomize_braph_WU' 'randomize_bct_U_edit_wei'};
pval_save_string = 'p_value_vs_bct';
types = {Graph.WD Graph.WD Graph.WU Graph.WU};
nodes = 100:10:190;

%% Locate method data
folder = what('randomize_analysis');
current_loc = folder.path;
data_path = path_append(current_loc, 'data');
addpath(data_path);

%% Method loop
for mi = 1:length(methods_gt)
    method_gt = methods_gt{mi};
    method_target = methods_target{mi};
    type = types{mi};
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
                fprintf('Running for density: %.3f\n', dens)
                target_measures = target_data(i).measures;
                gt_row = node_data_row(gt_data, dens, type);
                if gt_row <= length(gt_data)  % if gt data exists
                    gt_measures = gt_data(gt_row).measures;
                    comparison = calculate_pvalue_struct(gt_measures, target_measures);
                    target_data(i).(pval_save_string) = comparison;
                    if node == 10
                        target_data(i).p_value_gt = gt_data(gt_row).pValues;
                    else
                        target_data(i).p_value_gt = gt_data(gt_row).p_value_self;
                    end
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


