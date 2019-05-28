clear all, clc, close all;
%% Settings
methods = {'randomize_braph_BD'};  % braph name in data file
graph_types = {Graph.BD};
nodes = [200];
densities = [0.01];

% Measures to extract
meas = {
    'cpl_wsg',...
    'clustering_global',...
    'gleff_av',...
    'trans'};

curr_path = what('plot_distr');
fold = curr_path.path;

for mi=1:length(methods)
    meth = methods{mi};
    fprintf('------ Running for method: %s\n', meth)
    type = graph_types{mi};
    
    dir = Graph.is_directed(type);
    wei = Graph.is_weighted(type);
    if wei
        type_bin = 'wei';
    else
        type_bin = 'bin';
    end
    if dir
        type_dir = 'dir';
        if wei
            gt = 'randomize_bct_D';
            gt_edit = 'randomize_bct_D_edit';
        else
            gt = 'randomize_bct_D_bin';
            gt_edit = 'randomize_bct_D_edit_bin';
        end
    else
        type_dir = 'undir';
        if wei
            gt = 'randomize_bct_U';
            gt_edit = 'randomize_bct_U_edit';
        else
            gt = 'randomize_bct_U_bin';
            gt_edit = 'randomize_bct_U_edit_bin';
        end
    end
    
    %% Load data
    d = load(sprintf('data_%s.mat', gt));
    data_gt = d.data;
    d = load(sprintf('data_%s.mat', gt_edit));
    data_gt_edit = d.data;
    d = load(sprintf('data_%s.mat', meth));
    data_braph = d.data;
    
    for ni=1:length(nodes)
        n = nodes(ni);
        fprintf('------ Running for node size: %d\n', n);
        %% extract node data
        node_data_gt = data_gt(extractfield(data_gt, 'nodes') == n).node_data;
        node_data_gt_edit = data_gt_edit(extractfield(data_gt_edit, 'nodes') == n).node_data;
        node_data_braph = data_braph(extractfield(data_braph, 'nodes') == n).node_data;
        
        for di=1:length(densities)
            dens = densities(di);
            fprintf('------ Running for density: %.2f\n', dens);
            
            %% Extract row indices
            rowi_gt = node_data_row(node_data_gt, dens, type);
            rowi_gt_edit = node_data_row(node_data_gt_edit, dens, type);
            rowi_braph = node_data_row(node_data_braph, dens, type);
            
            for mj=1:length(meas)
                out_v = meas{mj};
                fprintf('------ Running for measure: %s\n', out_v)
                
                %% Extract distributions
                d_gt = extractfield(node_data_gt(rowi_gt).measures, out_v);
                d_gt_edit = extractfield(node_data_gt_edit(rowi_gt_edit).measures, out_v);
                d_braph = extractfield(node_data_braph(rowi_braph).measures, out_v);
                d_gt = d_gt(isfinite(d_gt));
                d_gt_edit = d_gt_edit(isfinite(d_gt_edit));
                d_braph = d_braph(isfinite(d_braph));
                fprintf('Size of bct data: %d\nSize of bct edit data: %d\nSize of braph data: %d\n', length(d_gt), length(d_gt_edit), length(d_braph))
                
                filename = sprintf('test_%s.mat', out_v);
                save_path = path_append(fold, filename);
                save(save_path, 'd_gt', 'd_gt_edit', 'd_braph')
            end
            
        end
        
    end
    
    
end