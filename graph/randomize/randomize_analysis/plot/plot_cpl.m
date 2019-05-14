function plot_cpl( curr_axes )
%PLOT_CPL Summary of this function goes here
%   Detailed explanation goes here

load('distr_cpl.mat')
fprintf('Size of bct data: %d\nSize of bct edit data: %d\nSize of braph data: %d\n', length(d_gt), length(d_gt_edit), length(d_comp))
axes(curr_axes);

xlab = {'$\mathrm{Characteristic}~\mathrm{pathlength}~\mathrm{wsg}$'};
colors = {[255 185 22]./255,[255 22 162]./255,[22 255 220]./255};
xlabposx = 6.5;
xlabposy = -0.02;
ylabposx = 5.3;
ylabposy = 0.14;

%% Plot figure
%Edge bins
nbr_of_bins = 8;
x_end_value = max([max(d_gt), max(d_gt_edit), max(d_comp)]);
x_start_value = min([min(d_gt), min(d_gt_edit), min(d_comp)]);
edges = linspace(x_start_value, x_end_value, nbr_of_bins);
x_values = edges(1:end-1) + (edges(2)-edges(1))/2;

%Sampling
nbr_of_groups = 10;
indices = randperm(length(d_gt), length(d_gt));
d_gt_shuffle = d_gt(indices);
d_gt_edit_shuffle = d_gt_edit(indices);
d_comp_shuffle = d_comp(indices);
elem_in_set = length(d_gt)/nbr_of_groups;
gt_mean = zeros(nbr_of_groups, length(x_values));  % Each row is one sample
gt_edit_mean = zeros(nbr_of_groups, length(x_values));
braph_mean = zeros(nbr_of_groups, length(x_values));

for i=1:nbr_of_groups-1
    subset_gt = d_gt_shuffle((i-1)*elem_in_set+1: i*elem_in_set);
    subset_gt_edit = d_gt_edit_shuffle((i-1)*elem_in_set+1: i*elem_in_set);
    subset_braph = d_comp_shuffle((i-1)*elem_in_set+1: i*elem_in_set);
    
    % Histcounts
    N_gt = histcounts(subset_gt, edges);
    N_gt_edit = histcounts(subset_gt_edit, edges);
    N_comp = histcounts(subset_braph, edges);
    
    % Normalize
    gt_mean(i, :) = N_gt./elem_in_set;
    gt_edit_mean(i, :) = N_gt_edit./elem_in_set;
    braph_mean(i, :) = N_comp./elem_in_set;
    
end

gt_std = std(gt_mean);  % STD of each col
gt_edit_std = std(gt_edit_mean);
braph_std = std(braph_mean);

% Hist data
N_gt = histcounts(d_gt, edges);
N_gt_edit = histcounts(d_gt_edit, edges);
N_comp = histcounts(d_comp, edges);

% Normalize
gt_values = N_gt./500;
gt_edit_values = N_gt_edit./500;
braph_values = N_comp./500;

y_max_value = max([max(gt_values), max(gt_edit_values), max(braph_values)]);
y_min_value = 0;


hold on;
w = (x_values(2)-x_values(1)) / 7;  %Divide by 7 since 2 bars, 2 half-bars and 1 space
for i=1:length(x_values)
    rectangle('Position', [x_values(i) - 3*w, 0, 2*w, gt_values(i)], 'FaceColor', colors{1})
%     plot([x_values(i) - 3*w + w/4, x_values(i) - w - w/4], [gt_values(i)-gt_std(i), gt_values(i)-gt_std(i)], 'black', 'LineWidth', .1)
%     plot([x_values(i) - 3*w + w/4, x_values(i) - w - w/4], [gt_values(i)+gt_std(i), gt_values(i)+gt_std(i)], 'black', 'LineWidth', .1)
    plot([x_values(i) - 2*w, x_values(i) - 2*w], [gt_values(i)-gt_std(i), gt_values(i)+gt_std(i)], 'black', 'LineWidth', .1)
    rectangle('Position', [x_values(i) - w, 0, 2*w, gt_edit_values(i)], 'FaceColor', colors{2})
%     plot([x_values(i) - w + w/4, x_values(i) + w - w/4], [gt_edit_values(i)-gt_edit_std(i), gt_edit_values(i)-gt_edit_std(i)], 'black', 'LineWidth', .1)
%     plot([x_values(i) - w + w/4, x_values(i) + w - w/4], [gt_edit_values(i)+gt_edit_std(i), gt_edit_values(i)+gt_edit_std(i)], 'black', 'LineWidth', .1)
    plot([x_values(i), x_values(i)], [gt_edit_values(i)-gt_edit_std(i), gt_edit_values(i)+gt_edit_std(i)], 'black', 'LineWidth', .1)
    rectangle('Position', [x_values(i) + w, 0, 2*w, braph_values(i)], 'FaceColor', colors{3})
%     plot([x_values(i) + w + w/4, x_values(i) + 3*w - w/4], [braph_values(i)-braph_std(i), braph_values(i)-braph_std(i)], 'black', 'LineWidth', .1)
%     plot([x_values(i) + w + w/4, x_values(i) + 3*w - w/4], [braph_values(i)+braph_std(i), braph_values(i)+braph_std(i)], 'black', 'LineWidth', .1)
    plot([x_values(i) + 2*w, x_values(i) + 2*w], [braph_values(i)-braph_std(i), braph_values(i)+braph_std(i)], 'black', 'LineWidth', .1)
end

% plot(x_values, gt_values, '-d', 'Color', colors{1})
% hold on
% plot(x_values, gt_edit_values, '-s', 'Color', colors{2})
% plot(x_values, braph_values, '-^', 'Color', colors{3})

xticks = linspace(x_start_value, x_end_value, 5);
yticks = linspace(0, y_max_value, 5);

plot(x_end_value*0.99, y_max_value*0.9, 's', 'Color', colors{1}, 'MarkerFaceColor', colors{1}, 'MarkerSize', 10)
plot(x_end_value*0.99, y_max_value*0.79, 's', 'Color', colors{2}, 'MarkerFaceColor', colors{2}, 'MarkerSize', 10)
plot(x_end_value*0.99, y_max_value*0.69, 's', 'Color', colors{3}, 'MarkerFaceColor', colors{3}, 'MarkerSize', 10)


h_max = maxis2d([x_start_value*0.9 x_end_value*1.1], [-0.01 y_max_value*1.5],...
    'X0', x_start_value,...
    'XTicks',xticks,...
    'XTickLabels',{sprintf('$%.2f$', xticks(1)),sprintf('$%.2f$', ...
    xticks(2)),sprintf('$%.2f$', xticks(3)),sprintf('$%.2f$', xticks(4)),...
    sprintf('$%.2f$', xticks(5)),},...
    'YTicks',yticks,...
    'YTickLabels',{sprintf('$%.2f$', yticks(1)),sprintf('$%.2f$', ...
    yticks(2)),sprintf('$%.2f$', yticks(3)),sprintf('$%.2f$', yticks(4)),...
    sprintf('$%.2f$', yticks(5)),},...
    'xlabel', xlab,...
    'XLabelPosition',[xlabposx xlabposy],...
    'ylabel', '$pdf$',...
    'YLabelPosition', [ylabposx ylabposy],...
    'StemWidth',0.5,...
    'HeadLength',8,...
    'HeadWidth',4,...
    'HeadNode',5,...
    'TickFontSize',12,...
    'labelfontsize',18);

text(x_end_value*0.95, y_max_value*0.9, ...
    '$\mathrm{BCT}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
text(x_end_value*0.95, y_max_value*0.82, ...
    '$\mathrm{BCT}~\mathrm{edit}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
text(x_end_value*0.95, y_max_value*0.74, ...
    '$\mathrm{BRAPH}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)

% set(h_max.ylabel,'Rotation',90);
for h1 = h_max.yticklabels
    set(h1,'Position',get(h1,'Position')-[0.1 .0 0]);
end
h2 = h_max.yticks;
for h2_loop = 1:1:length(h2)
    a = h2(h2_loop);
    set(a,'XData',a.XData - 0.1)
end
h3 = h_max.xticks;
for h3_loop = 1:1:length(h3)
    a = h3(h3_loop);
    set(a,'YData',a.YData - 0.003)
end
for h4 = h_max.xticklabels
    set(h4,'Position',get(h4,'Position')-[0 .015 0]);
end
end
