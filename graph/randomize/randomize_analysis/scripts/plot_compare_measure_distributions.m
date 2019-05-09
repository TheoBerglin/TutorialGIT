function plot_compare_measure_distributions(comp_func, density, meas, nodes, type, orig_val)
%PLOT_COMPARE_MEAS_DISTRIBUTIONS Summary of this function goes here
%   Detailed explanation goes here
%% Ground truth
directed = Graph.is_directed(type);
weighted = Graph.is_weighted(type);
if directed
    gt = 'randomize_bct_D';
    gt_edit = 'randomize_bct_D_edit';
else 
    gt = 'randomize_bct_U';
    gt_edit = 'randomize_bct_U_edit';
end

%% Load data
d = load(sprintf('data_%s.mat', gt));
data_gt = d.data;
d = load(sprintf('data_%s.mat', gt_edit));
data_gt_edit = d.data;
d = load(sprintf('data_%s.mat', comp_func));
data_comp = d.data;
%% extract node data
node_data_gt = data_gt(extractfield(data_gt, 'nodes') == nodes).node_data;
node_data_gt_edit = data_gt_edit(extractfield(data_gt_edit, 'nodes') == nodes).node_data;
node_data_comp = data_comp(extractfield(data_comp, 'nodes') == nodes).node_data;
%% Extract row indices
rowi_gt = node_data_row(node_data_gt, density, type);
rowi_gt_edit = node_data_row(node_data_gt_edit, density, type);
rowi_comp = node_data_row(node_data_comp, density, type);
%% Extract distributions
d_gt = extractfield(node_data_gt(rowi_gt).measures, meas);
d_gt_edit = extractfield(node_data_gt_edit(rowi_gt_edit).measures, meas);
d_comp = extractfield(node_data_comp(rowi_comp).measures, meas);
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
xlabel(sprintf('%s' , meas))
% fprintf('Size of ground truth data: %d\nSize of compare data: %d\n', length(d_gt), length(d_comp))
% fprintf('Mean of ground truth data: %.4f\nMean of compare data: %.4f\n', mean(d_gt), mean(d_comp))
% fprintf('Standard deviation of ground truth data: %.4f\nStandard deviation of compare data: %.4f\n', std(d_gt), std(d_comp))
fprintf('Original value: %.4f\n', orig_val)

end

