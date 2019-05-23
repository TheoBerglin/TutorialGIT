function plot_wei_wu(  )
%PLOT_DEG Summary of this function goes here
%   Detailed explanation goes here

load('deg_wu_200_001.mat')
fprintf('Size of bct data: %d\nSize of bct edit data: %d\nSize of braph data: %d\n', length(bct_wei), length(bct_edit_wei), length(braph_wei))

xlab = {'$\mathrm{Edge}~\mathrm{weights}$'};
colors = {[255 185 22]./255,[255 22 162]./255,[22 255 220]./255};
xlabposx = 0.65;
xlabposy = -0.07;
ylabposx = 0.45;
ylabposy = 0.345;
nbr_of_vals = length(bct_wei);
%% Plot figure
%Edge bins
nbr_of_bins = 8;
x_end_value = 1;
x_start_value = .3;
edges = linspace(x_start_value, x_end_value, nbr_of_bins);
x_values = edges(1:end-1) + (edges(2)-edges(1))/2;

%Sampling
nbr_of_groups = 10;
indices = randperm(length(bct_wei), length(bct_wei));
d_gt_shuffle = bct_wei(indices);
d_gt_edit_shuffle = bct_edit_wei(indices);
d_comp_shuffle = braph_wei(indices);
elem_in_set = ceil(length(bct_wei)/nbr_of_groups);
gt_mean = zeros(nbr_of_groups, length(x_values));  % Each row is one sample
gt_edit_mean = zeros(nbr_of_groups, length(x_values));
braph_mean = zeros(nbr_of_groups, length(x_values));
elems_left = length(bct_wei);

for i=1:nbr_of_groups
    if elems_left < elem_in_set
        subset_gt = d_gt_shuffle((i-1)*elem_in_set+1: end);
        subset_gt_edit = d_gt_edit_shuffle((i-1)*elem_in_set+1: end);
        subset_braph = d_comp_shuffle((i-1)*elem_in_set+1: end);
        elem_in_set = elems_left;
    else
        subset_gt = d_gt_shuffle((i-1)*elem_in_set+1: i*elem_in_set);
        subset_gt_edit = d_gt_edit_shuffle((i-1)*elem_in_set+1: i*elem_in_set);
        subset_braph = d_comp_shuffle((i-1)*elem_in_set+1: i*elem_in_set);
        elems_left = elems_left - elem_in_set;
    end
    
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
N_gt = histcounts(bct_wei, edges);
N_gt_edit = histcounts(bct_edit_wei, edges);
N_comp = histcounts(braph_wei, edges);

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

yticks = linspace(0.1, 0.3, 3);

plot(1, 0.3, 's', 'Color', colors{1}, 'MarkerFaceColor', colors{1}, 'MarkerSize', 10)
plot(1, 0.275, 's', 'Color', colors{2}, 'MarkerFaceColor', colors{2}, 'MarkerSize', 10)
plot(1, 0.25, 's', 'Color', colors{3}, 'MarkerFaceColor', colors{3}, 'MarkerSize', 10)


h_max = maxis2d([x_start_value*0.9 x_end_value*1.1], [-0.01 y_max_value*1.7],...
    'X0', x_start_value,...
    'XTicks',x_values,...
    'XTickLabels',{sprintf('$%.2f$', x_values(1)),sprintf('$%.2f$', x_values(2)),...
    sprintf('$%.2f$', x_values(3)),sprintf('$%.2f$', x_values(4)),...
    sprintf('$%.2f$', x_values(5)),sprintf('$%.2f$', x_values(6)),...
    sprintf('$%.2f$', x_values(7))},...
    'YTicks',yticks,...
    'YTickLabels',{sprintf('$%.1f$', yticks(1)),sprintf('$%.1f$', ...
    yticks(2)),sprintf('$%.1f$', yticks(3))},...
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

text(1.05, .3, ...
    '$\mathrm{BCT}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
text(1.05, .275, ...
    '$\mathrm{BCT}~\mathrm{edit}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
text(1.05, .25, ...
    '$\mathrm{BRAPH}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)

% set(h_max.ylabel,'Rotation',90);
for h1 = h_max.yticklabels
    set(h1,'Position',get(h1,'Position')-[0.05 .0 0]);
end
h2 = h_max.yticks;
for h2_loop = 1:1:length(h2)
    a = h2(h2_loop);
    set(a,'XData',a.XData - 0.02)
end
h3 = h_max.xticks;
for h3_loop = 1:1:length(h3)
    a = h3(h3_loop);
    set(a,'YData',a.YData - 0.009)
end
for h4 = h_max.xticklabels
    set(h4,'Position',get(h4,'Position')-[0 .035 0]);
end
set(h_max.xticklabels,'Rotation',45);

end
