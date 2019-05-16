function plot_deg(  )
%PLOT_DEG Summary of this function goes here
%   Detailed explanation goes here

load('deg_bu_200_001.mat')
fprintf('Size of bct data: %d\nSize of bct edit data: %d\nSize of braph data: %d\n', length(bct_deg), length(bct_edit_deg), length(braph_deg))

xlab = {'$\mathrm{Nodal}~\mathrm{degree}$'};
colors = {[255 185 22]./255,[255 22 162]./255,[22 255 220]./255};
xlabposx = 4;
xlabposy = -0.12;
ylabposx = 1.9;
ylabposy = 0.57;

nbr_of_vals = length(bct_deg);
%% Plot figure
%Edge bins
nbr_of_bins = 8;
x_end_value = 7.5;
x_start_value = .5;
edges = linspace(x_start_value, x_end_value, nbr_of_bins);
x_values = edges(1:end-1) + (edges(2)-edges(1))/2;

%Sampling
nbr_of_groups = 10;
indices = randperm(length(bct_deg), length(bct_deg));
d_gt_shuffle = bct_deg(indices);
d_gt_edit_shuffle = bct_edit_deg(indices);
d_comp_shuffle = braph_deg(indices);
elem_in_set = length(bct_deg)/nbr_of_groups;
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
N_gt = histcounts(bct_deg, edges);
N_gt_edit = histcounts(bct_edit_deg, edges);
N_comp = histcounts(braph_deg, edges);

% Normalize
gt_values = N_gt./nbr_of_vals;
gt_edit_values = N_gt_edit./nbr_of_vals;
braph_values = N_comp./nbr_of_vals;

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

yticks = linspace(0.1, 0.4, 4);

plot(x_end_value*0.6, 0.445, 's', 'Color', colors{1}, 'MarkerFaceColor', colors{1}, 'MarkerSize', 10)
plot(x_end_value*0.6, 0.405, 's', 'Color', colors{2}, 'MarkerFaceColor', colors{2}, 'MarkerSize', 10)
plot(x_end_value*0.6, 0.365, 's', 'Color', colors{3}, 'MarkerFaceColor', colors{3}, 'MarkerSize', 10)


h_max = maxis2d([x_start_value*0.6 x_end_value*1.1], [-0.02 y_max_value*1.7],...
    'X0', x_start_value,...
    'XTicks',x_values,...
    'XTickLabels',{sprintf('$%.0f$', x_values(1)),sprintf('$%.0f$', x_values(2)),...
    sprintf('$%.0f$', x_values(3)),sprintf('$%.0f$', x_values(4)),...
    sprintf('$%.0f$', x_values(5)),sprintf('$%.0f$', x_values(6)),...
    sprintf('$%.0f$', x_values(7))},...
    'YTicks',yticks,...
    'YTickLabels',{sprintf('$%.1f$', yticks(1)),sprintf('$%.1f$', ...
    yticks(2)),sprintf('$%.1f$', yticks(3)),sprintf('$%.1f$', yticks(4))},...
    'xlabel', xlab,...
    'XLabelPosition',[xlabposx xlabposy],...
    'ylabel', '$\mathrm{pdf}~\mathrm{(n.u)}$',...
    'YLabelPosition', [ylabposx ylabposy],...
    'StemWidth',0.2,...
    'HeadLength',8,...
    'HeadWidth',4,...
    'HeadNode',5,...
    'TickFontSize',14,...
    'labelfontsize',18);

text(x_end_value*0.65, .44, ...
    '$\mathrm{BCT}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
text(x_end_value*0.65, .4, ...
    '$\mathrm{BCT}~\mathrm{edit}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
text(x_end_value*0.65, .36, ...
    '$\mathrm{BRAPH}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)

% set(h_max.ylabel,'Rotation',90);
for h1 = h_max.yticklabels
    set(h1,'Position',get(h1,'Position')-[0.4 .0 0]);
end
h2 = h_max.yticks;
for h2_loop = 1:1:length(h2)
    a = h2(h2_loop);
    set(a,'XData',a.XData - 0.2)
end
h3 = h_max.xticks;
for h3_loop = 1:1:length(h3)
    a = h3(h3_loop);
    set(a,'YData',a.YData - 0.016)
end
for h4 = h_max.xticklabels
    set(h4,'Position',get(h4,'Position')-[0 .025 0]);
end
% set(h_max.xticklabels,'Rotation',45);

end
