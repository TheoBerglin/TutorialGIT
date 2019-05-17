function plot_fdr(  )
%PLOT_FDR Summary of this function goes here
%   Detailed explanation goes here


load('fdr_bu.mat')

xlab = {'$\mathrm{Sample}~\mathrm{index}$'};
colors = {[255 185 22]./255,[255 22 162]./255,[22 255 220]./255};
xlabposx = 120;
xlabposy = -0.22;
ylabposx = 20;
ylabposy = 1.1;

%% Plot figure
x_end_value = length(p_val_braph_bct);
x_start_value = 1;
x_values = linspace(x_start_value, x_end_value, x_end_value);

y_max_value = 1;
y_min_value = 0;

hold on;
plot(x_values, sort(p_val_braph_bct), 'Color', colors{1})
plot(x_values, sort(p_val_braph_bcted), 'Color', colors{2})
plot(x_values, sort(p_val_bcted_bct), 'Color', colors{3})
plot(x_values, 0.05*x_values/x_end_value, 'Color', 'black');

xticks = linspace(30, 210, 7);
yticks = linspace(0.2, 1, 5);

plot([x_end_value*0.6, x_end_value*0.6+8], [0.445, 0.445], 'Color', colors{1}, 'LineWidth', 2)
plot([x_end_value*0.6, x_end_value*0.6+8], [0.37, 0.37], 'Color', colors{2}, 'LineWidth', 2)
plot([x_end_value*0.6, x_end_value*0.6+8], [0.295, 0.295], 'Color', colors{3}, 'LineWidth', 2)
% plot([x_end_value*0.6, x_end_value*0.6+8], [0.22, 0.22], 'Color', 'black', 'LineWidth', 2)


h_max = maxis2d([x_start_value-10 x_end_value*1.1], [-0.03 y_max_value*1.1],...
    'X0', x_start_value,...
    'XTicks',xticks,...
    'XTickLabels',{sprintf('$%.0f$', xticks(1)),sprintf('$%.0f$', xticks(2)),...
    sprintf('$%.0f$', xticks(3)),sprintf('$%.0f$', xticks(4)),...
    sprintf('$%.0f$', xticks(5)),sprintf('$%.0f$', xticks(6)),...
    sprintf('$%.0f$', xticks(7))},...
    'YTicks',yticks,...
    'YTickLabels',{sprintf('$%.1f$', yticks(1)),sprintf('$%.1f$', ...
    yticks(2)),sprintf('$%.1f$', yticks(3)),sprintf('$%.1f$', yticks(4)),...
    sprintf('$%.1f$', yticks(5))},...
    'xlabel', xlab,...
    'XLabelPosition',[xlabposx xlabposy],...
    'ylabel', '$p$',...
    'YLabelPosition', [ylabposx ylabposy],...
    'StemWidth',0.2,...
    'HeadLength',8,...
    'HeadWidth',4,...
    'HeadNode',5,...
    'TickFontSize',14,...
    'labelfontsize',18);

text(x_end_value*0.65, .44, ...
    '$\mathrm{Braph}~\mathrm{vs}~\mathrm{BCT}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',16)
text(x_end_value*0.65, .365, ...
    '$\mathrm{Braph}~\mathrm{vs}~\mathrm{BCT}~\mathrm{edit}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',16)
text(x_end_value*0.65, .29, ...
    '$\mathrm{BCT}~\mathrm{edit}~\mathrm{vs}~\mathrm{BCT}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',16)
text(x_end_value*0.8, .1, ...
    '$q=0.05$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',16)

% set(h_max.ylabel,'Rotation',90);
for h1 = h_max.yticklabels
    set(h1,'Position',get(h1,'Position')-[8 .0 0]);
end
h2 = h_max.yticks;
for h2_loop = 1:1:length(h2)
    a = h2(h2_loop);
    set(a,'XData',a.XData - 5)
end
h3 = h_max.xticks;
for h3_loop = 1:1:length(h3)
    a = h3(h3_loop);
    set(a,'YData',a.YData - 0.025)
end
for h4 = h_max.xticklabels
    set(h4,'Position',get(h4,'Position')-[0 .035 0]);
end
% set(h_max.xticklabels,'Rotation',45);

end

