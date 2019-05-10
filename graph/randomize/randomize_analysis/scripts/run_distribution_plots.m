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

                %% Extract distributions
                d_gt = extractfield(node_data_gt(rowi_gt).measures, out_v);
                d_gt_edit = extractfield(node_data_gt_edit(rowi_gt_edit).measures, out_v);
                d_comp = extractfield(node_data_comp(rowi_comp).measures, out_v);
                d_gt = d_gt(isfinite(d_gt));
                d_gt_edit = d_gt_edit(isfinite(d_gt_edit));
                d_comp = d_comp(isfinite(d_comp));
                fprintf('Size of bct data: %d\nSize of bct edit data: %d\nSize of braph data: %d\n', length(d_gt), length(d_gt_edit), length(d_comp))
                
                %% Plot figure
                %Edge bins
                end_value = max([max(d_gt), max(d_gt_edit), max(d_comp)]);
                start_value = min([min(d_gt), min(d_gt_edit), min(d_comp)]);
                edges = linspace(start_value, end_value, 25);
                
                %BCT
                h_gt = histogram(d_gt, edges);
                hold on
                
                %BCT edit
                h_gt_edit = histogram(d_gt_edit, edges);
                
                %BRAPH
                h_braph = histogram(d_comp, edges);
                
                %Original value
                max_value = max([max(h_gt.Values), max(h_gt_edit.Values), max(h_braph.Values)]);
                plot(orig_val, linspace(0,max_value), '-g.', 'LineWidth', 20);
                                
                %Normalize
                gt_values = h_gt.Values./500;
                gt_edit_values = h_gt_edit.Values./500;
                braph_values = h_braph.Values./500;
                x_values = h_gt.BinEdges(1:end-1) + h_gt.BinWidth/2;
                
                clf;

                
                plot(x_values, smooth(gt_values), '-d')
                hold on
                plot(x_values, smooth(gt_edit_values), '-s')
                plot(x_values, smooth(braph_values), '-^')
                maxis2d([0 5], [0 10])
%                 maxis2d([0 65],[0 80]*1/factory,...
%     'XTicks',xticks,...
%     'XTickLabels','',...
%     'X0',0,...
%     'xlim',[-1.5 68],...
%     'yticks',[0.05 0.25 0.45],...
%     'YTickLabels',{'$\mathrm{0.05}$','$\mathrm{0.25}$','$\mathrm{0.45}$'},...
%     'Y0',0,...
%     'ylim',[-3 81]*1/factory,...
%     'xlabel','','XLabelPosition',[75 -11],...
%     'ylabel','$\mathrm{clustering}~\mathrm{coefficient}$','YLabelPosition',[-11 40*1/factory],...
%     'StemWidth',0.5,...
%     'HeadLength',8,...
%     'HeadWidth',4,...
%     'HeadNode',5,...
%     'TickFontSize',12,...
%     'labelfontsize',15);
                
                xlabel(sprintf('%s' , out_v))
                fprintf('Original value: %.4f\n', orig_val)
            end
            suptitle(sprintf('Type: %s, %s, Size: %d, Density: %.4f', type_bin, type_dir, n, dens))
            lh = legend('braph', 'braph', 'bct', 'bct', 'original value', 'Location', 'best');
            set(lh,'position',[.01 .5 .1 .1])
        end
        
    end
    
    
end