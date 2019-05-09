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
    else
        type_dir = 'undir';
    end
    
    for ni=1:length(nodes)
        n = nodes(ni);
        fprintf('------ Running for node size: %d\n', n);
        for di=1:length(densities)
            dens = densities(di);
            fprintf('------ Running for density: %.2f\n', dens);
            figure();
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
                plot_compare_measure_distributions(meth, dens, out_v, n, type, orig_val)
            end
            suptitle(sprintf('Type: %s, %s, Size: %d, Density: %.4f', type_bin, type_dir, n, dens))
            lh = legend('braph', 'braph', 'bct', 'bct', 'original value', 'Location', 'best');
            set(lh,'position',[.01 .5 .1 .1])
        end
        
    end
    
    
end