function plot_cpl( curr_axes )
%PLOT_CPL Summary of this function goes here
%   Detailed explanation goes here


xlab = {'$\mathrm{Characteristic}~\mathrm{pathlength}~\mathrm{wsg}$'};
colors = {[148 0 211]./255,[0 0 0]./255,[255 0 0]./255};

load('distr_cpl.mat')
fprintf('Size of bct data: %d\nSize of bct edit data: %d\nSize of braph data: %d\n', length(d_gt), length(d_gt_edit), length(d_comp))
axes(curr_axes);
xlabposx = 6.5;
xlabposy = -0.02;
ylabposx = 5.3;
ylabposy = 0.14;

%% Plot figure
%Edge bins
end_value = max([max(d_gt), max(d_gt_edit), max(d_comp)]);
start_value = min([min(d_gt), min(d_gt_edit), min(d_comp)]);
edges = linspace(start_value, end_value, 25);

%     %BCT
%     h_gt = histogram(d_gt, edges);
%     hold on
%
%     %BCT edit
%     h_gt_edit = histogram(d_gt_edit, edges);
%
%     %BRAPH
%     h_braph = histogram(d_comp, edges);
%
%     %Original value
%     max_value = max([max(h_gt.Values), max(h_gt_edit.Values), max(h_braph.Values)]);
%
%
%     %Normalize
%     gt_values = h_gt.Values./500;
%     gt_edit_values = h_gt_edit.Values./500;
%     braph_values = h_braph.Values./500;
%     x_values = h_gt.BinEdges(1:end-1) + h_gt.BinWidth/2;

% Hist data
N_gt = histcounts(d_gt, edges);
N_gt_edit = histcounts(d_gt_edit, edges);
N_comp = histcounts(d_comp, edges);

% Normalize
gt_values = N_gt./500;
gt_edit_values = N_gt_edit./500;
braph_values = N_comp./500;

max_value = max([max(gt_values), max(gt_edit_values), max(braph_values)]);


x_values = edges(1:end-1) + (edges(2)-edges(1))/2;
%     bar([gt_values; gt_edit_values; braph_values])
plot(x_values, gt_values, '-d', 'Color', colors{1})
hold on
plot(x_values, gt_edit_values, '-s', 'Color', colors{2})
plot(x_values, braph_values, '-^', 'Color', colors{3})

xticks = linspace(start_value, end_value, 5);
yticks = linspace(0, max_value, 5);

marker = {'d','s','^'};
marker_size = 1;
line_width = 1;

plot(end_value*0.93, max_value*0.9, marker{1}, 'Color', colors{1})
plot(end_value*0.93, max_value*0.82, marker{2}, 'Color', colors{2})
plot(end_value*0.93, max_value*0.74, marker{3}, 'Color', colors{3})


h_max = maxis2d([start_value*0.9 end_value*1.1], [-0.01 max_value*1.1],...
    'X0', start_value,...
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
    'labelfontsize',15);

y_pos1 = -6*1/100;
y_pos2 = y_pos1 - 4.75*1/100;


text(end_value*0.95, max_value*0.9, ...
    '$\mathrm{BCT}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',15)
text(end_value*0.95, max_value*0.82, ...
    '$\mathrm{BCT}~\mathrm{edit}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',15)
text(end_value*0.95, max_value*0.74, ...
    '$\mathrm{BRAPH}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',15)

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

end

