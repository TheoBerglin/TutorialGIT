function plot_binary_undirected(  )
%PLOT_CPL Summary of this function goes here
%   Detailed explanation goes here

bin = 'binary';
dir_type = 'undirected';
dir_type_opposite = 'apa';

%xlab = {'$\mathrm{Clustering}~\mathrm{global}$'};
colors = {[255 185 22]./255,[255 22 162]./255,[22 255 220]./255};
xlabposx = 0.017;
xlabposy = -0.18;
ylabposx = 0.0075;
ylabposy = 0.78;

% xlab = {'$\mathrm{Transitivity}$'};
colors = {[255 185 22]./255,[255 22 162]./255,[22 255 220]./255};
xlabposx = 0.02;
xlabposy = -0.14;
ylabposx = 0.011;
ylabposy = 0.575;

%% Plot figure
data_name = 'binary_undirected_plot_data';
plot_speed_data_func(bin, dir_type, dir_type_opposite, data_name);
load(data_name);
x_min = inf;
x_max = -inf;
y_min = inf;
y_max = -inf;
%figure()
colors = {[255 185 22]./255,[255 22 162]./255,[22 255 220]./255};
for i = 1:length(save_data)
    if contains(save_data(i).DisplayName, 'BCT_edit')
        plot_style = 'o';
        plot_color = colors{1};
        
    elseif  contains(save_data(i).DisplayName, 'BCT_special')
        plot_style = 'd';
        plot_color = 'y';
    elseif contains(save_data(i).DisplayName, 'BCT')
        plot_style = '^';
        plot_color = colors{2};
    else
        plot_style = 's';
        plot_color = colors{3};
    end
    plot(log(save_data(i).x), log(save_data(i).y), plot_style, 'MarkerFaceColor', plot_color, 'MarkerEdgeColor', 'k');
    hold on
    if max(save_data(i).x) > x_max
        x_max = max(save_data(i).x);
    end
    if max(save_data(i).y) > y_max
        y_max = max(save_data(i).y);
    end
    if min(save_data(i).x) < x_min
        x_min = min(save_data(i).x);
    end
    if min(save_data(i).y) < y_min
        y_min = min(save_data(i).y);
    end
    
end

nbr_of_bins = 5;
x_end_value = x_max;
x_start_value = x_min;
edges = linspace(x_start_value, x_end_value, nbr_of_bins);
%x_values = log(edges(1:end-1) + (edges(2)-edges(1))/2);
x_values = log([200 1e3 1e4 1e5]);
%plot(x, y)
hold on
y_max_value = y_max;
y_min_value = y_min;
%yticks = logspace(y_min_value, y_max_value, 5);
yticks = log([1e-4 1e-3 1e-2 1e-1 1 10 100 1e3]);
xlab = {'$\l{Transitivity}$'};
colors = {[255 185 22]./255,[255 22 162]./255,[22 255 220]./255};
xlabposx = log(5e3);
xlabposy = -13;
ylabposx = 6.5;
ylabposy = log(25e3);
% plot(x_end_value*0.7, 0.465, 's', 'Color', colors{1}, 'MarkerFaceColor', colors{1}, 'MarkerSize', 10)
% plot(x_end_value*0.7, 0.415, 's', 'Color', colors{2}, 'MarkerFaceColor', colors{2}, 'MarkerSize', 10)
% plot(x_end_value*0.7, 0.365, 's', 'Color', colors{3}, 'MarkerFaceColor', colors{3}, 'MarkerSize', 10)
xlab = 'Nodes';
ylab = 'Time [s]';
h_max = maxis2d([log(x_start_value*0.65) log(2.5e5)], [log(y_min_value*0.1) log(25e3)],...
    'X0', 5,...
    'Y0', -10,...
    'XTicks',x_values,...
    'XTickLabels',{'200', '$10^3$', '$10^4$', '$10^5$'},...
    'YTicks',yticks,... % [1e-5 1e-4 1e-3 1e-2 1e-1 1 10 100 1e3];
    'YTickLabels',{'$10^{-4}$','$10^{-3}$', '$10^{-2}$', '$10^{-1}$', '', '$10$  ','$10^2$','$10^3$'},...
    'xlabel', xlab,...
    'XLabelPosition',[xlabposx xlabposy],...
    'StemWidth',0.2,...
    'ylabel', ylab,...
    'YLabelPosition',[ylabposx ylabposy],...
    'HeadLength',10,...
    'HeadWidth',5,...
    'HeadNode',5,...
    'TickFontSize',14,...
    'labelfontsize',18);



text(x_end_value*0.75, 0.46, ...
    '$\mathrm{BCT}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
text(x_end_value*0.75, 0.41, ...
    '$\mathrm{BCT}~\mathrm{edit}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
text(x_end_value*0.75, 0.36, ...
    '$\mathrm{BRAPH}$','Interpreter','latex',...
    'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)

%set(h_max.ylabel,'Rotation',90);
for h1 = h_max.yticklabels
    set(h1,'Position',get(h1,'Position')-[0.18 .0 0]);
end
h2 = h_max.yticks;
for h2_loop = 1:1:length(h2)
    a = h2(h2_loop);
    set(a,'XData',a.XData - 0.14)
end
h3 = h_max.xticks;
for h3_loop = 1:1:length(h3)
    a = h3(h3_loop);
    set(a,'YData',a.YData - 0.35)
end

for h4 = h_max.xticklabels
    %set(h4,'Position',get(h4,'Position')-[0 1.2 0]);
    set(h4,'Position',get(h4,'Position')-[0 0.2 0]);
end
%set(h_max.xticklabels,'Rotation',45);
set(h_max.xticklabels,'Rotation',0);
end