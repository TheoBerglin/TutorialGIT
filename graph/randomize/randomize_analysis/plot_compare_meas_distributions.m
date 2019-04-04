function plot_compare_meas_distributions(density, meas, nodes, type)
%PLOT_COMPARE_MEAS_DISTRIBUTIONS Summary of this function goes here
%   Detailed explanation goes here
%% Ground truth
directed = Graph.is_directed(type);
weighted = Graph.is_weighted(type);
if directed
    gt = 'randomize_bct_D';
else 
    gt = 'randomize_bct_U';
end
%% Our data
if directed && weighted
    comp = 'randomize_combo_WD_fix';
elseif ~directed && weighted
    comp = 'randomize_combo_WU_fix';
elseif directed && ~weighted
    comp = 'randomize_braph_BD';
else
    comp = 'randomize_braph_BU';
end

%% Load data
d = load(sprintf('data_%s.mat', gt));
data_gt = d.data;
d = load(sprintf('data_%s.mat', comp));
data_comp = d.data;
%% extract node data
node_data_gt = data_gt(extractfield(data_gt, 'nodes') == nodes).node_data;
node_data_comp = data_comp(extractfield(data_comp, 'nodes') == nodes).node_data;
%% Extract row indices
rowi_gt = node_data_row(node_data_gt, density, type);
rowi_comp = node_data_row(node_data_comp, density, type);
%% Extract distributions
d_gt = extractfield(node_data_gt(rowi_gt).measures, meas);
d_comp = extractfield(node_data_comp(rowi_comp).measures, meas);
d_gt = d_gt(isfinite(d_gt));
d_comp = d_comp(isfinite(d_comp));
%% Plot figure
figure()
h1 =histfit(d_comp);
h1(2).Color = 'b';
h1(1).FaceAlpha = 0.5;
hold on
h2 =histfit(d_gt);
h2(2).Color = 'r';
h2(1).FaceAlpha = 0.5;
legend('braph', 'braph', 'bct', 'bct')
title(sprintf('Measure: %s', replace(meas, '_', '\_')))
fprintf('Size of ground truth data: %d\nSize of compare data: %d\n', length(d_gt), length(d_comp))
fprintf('Mean of ground truth data: %.4f\nMean of compare data: %.4f\n', mean(d_gt), mean(d_comp))
fprintf('Standard deviation of ground truth data: %.4f\nStandard deviation of compare data: %.4f\n', std(d_gt), std(d_comp))

end

