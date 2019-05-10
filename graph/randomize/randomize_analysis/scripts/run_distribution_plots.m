clear all, clc, close all;
%% Settings
% methods = {'randomize_braph_BD' 'randomize_braph_BU' ...
%     'randomize_bct_D_edit' 'randomize_bct_U_edit'};
methods = {'randomize_braph_BU'};
graph_types = {Graph.BU};
nodes = [200];
densities = [0.01];

measures = {
    'characteristic_pathlength_wsg',...
    'clustering_global',...
    'global_efficiency_average',...
    'transitivity'};

out_var = {
    'cpl_wsg',...
    'clustering_global',...
    'gleff_av',...
    'trans'};

% measures = {'characteristic_pathlength_wsg'};
% out_var = {'cpl_wsg'};

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
        gt = 'randomize_bct_D';
        gt_edit = 'randomize_bct_D_edit';
    else
        type_dir = 'undir';
        gt = 'randomize_bct_U';
        gt_edit = 'randomize_bct_U_edit';
    end
    
    %% Load data
    d = load(sprintf('data_%s.mat', gt));
    data_gt = d.data;
    d = load(sprintf('data_%s.mat', gt_edit));
    data_gt_edit = d.data;
    d = load(sprintf('data_%s.mat', meth));
    data_comp = d.data;
    
    for ni=1:length(nodes)
        n = nodes(ni);
        fprintf('------ Running for node size: %d\n', n);
        %% extract node data
        node_data_gt = data_gt(extractfield(data_gt, 'nodes') == n).node_data;
        node_data_gt_edit = data_gt_edit(extractfield(data_gt_edit, 'nodes') == n).node_data;
        node_data_comp = data_comp(extractfield(data_comp, 'nodes') == n).node_data;
                
        for di=1:length(densities)
            dens = densities(di);
            fprintf('------ Running for density: %.2f\n', dens);
            figure();
            %% Extract row indices
            rowi_gt = node_data_row(node_data_gt, dens, type);
            rowi_gt_edit = node_data_row(node_data_gt_edit, dens, type);
            rowi_comp = node_data_row(node_data_comp, dens, type);
                
            load_file = sprintf('dens_%s_nodes_%d_%s_%s.txt', num2str(dens, '%.3f'), n, type_bin, type_dir);  %
            if exist(load_file, 'file')
                A = load(load_file);
            else
                disp('Failed to load matrix')
            end
            for mj=1:length(measures)
                meas = measures{mj};
                out_v = out_var{mj};
                eval(sprintf('orig_val = %s(A, type);', meas))
                fprintf('------ Running for measure: %s\n', out_v)
                subplot(2, 2, mj)

                %% Extract distributions
                d_gt = extractfield(node_data_gt(rowi_gt).measures, out_v);
                d_gt_edit = extractfield(node_data_gt_edit(rowi_gt_edit).measures, out_v);
                d_comp = extractfield(node_data_comp(rowi_comp).measures, out_v);
                d_gt = d_gt(isfinite(d_gt));
                d_gt_edit = d_gt_edit(isfinite(d_gt_edit));
                d_comp = d_comp(isfinite(d_comp));
                %% Plot figure
                %Braph
                h1 =histfit(d_comp);
                h1(2).Color = 'b';
                % delete(h1(1));
                h1(1).FaceColor = 'b';
                h1(1).FaceAlpha = 0.5;
                hold on
                
                %BCT
                h2 =histfit(d_gt);
                h2(2).Color = 'r';
                % delete(h2(1));
                h2(1).FaceColor = 'r';
                h2(1).FaceAlpha = 0.5;
                
                %BCT edit
                % h3 =histfit(d_gt_edit);
                % h3(2).Color = 'r';
                % % delete(h3(1));
                % h3(1).FaceColor = 'r';
                % h3(1).FaceAlpha = 0.5;
                
                %Normalize
                % max_value = max([max(h1(2).YData), max(h2(2).YData), max(h3(2).YData)]);
                % h1(2).YData = h1(2).YData./max_value;
                % h2(2).YData = h2(2).YData./max_value;
                % h3(2).YData = h3(2).YData./max_value;
                
                % plot(orig_val, linspace(0,max([max(h1(2).YData), max(h2(2).YData), max(h3(2).YData)])), '-g.', 'LineWidth', 20);
                plot(orig_val, linspace(0,max([max(h1(2).YData), max(h2(2).YData)])), '-g.', 'LineWidth', 20);
                
                % xmin = min([min(h1(2).XData), min(h2(2).XData), min(h3(2).XData)]);
                % xmax = max([max(h1(2).XData), max(h2(2).XData), max(h3(2).XData)]);
                xmin = min([min(h1(2).XData), min(h2(2).XData)]);
                xmax = max([max(h1(2).XData), max(h2(2).XData)]);
                xlim([xmin xmax])
                xlabel(sprintf('%s' , out_v))
                % fprintf('Size of ground truth data: %d\nSize of compare data: %d\n', length(d_gt), length(d_comp))
                % fprintf('Mean of ground truth data: %.4f\nMean of compare data: %.4f\n', mean(d_gt), mean(d_comp))
                % fprintf('Standard deviation of ground truth data: %.4f\nStandard deviation of compare data: %.4f\n', std(d_gt), std(d_comp))
                fprintf('Original value: %.4f\n', orig_val)
            end
            suptitle(sprintf('Type: %s, %s, Size: %d, Density: %.4f', type_bin, type_dir, n, dens))
            lh = legend('braph', 'braph', 'bct', 'bct', 'original value', 'Location', 'best');
            set(lh,'position',[.01 .5 .1 .1])
        end
        
    end
    
    
end