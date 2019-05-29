clc, clear all, clf, close all;

% Data for BU, size: 200, dens:0.01

f1 = figure();
set(f1,'Color','w','Position',[100 40 700 730])
%% global parameters
size_x_axes = 250;
size_y_axes = 250;
% 
xpos_col1 = 55;
xpos_col2 = 410;

ypos_row3 = 540;
ypos_row2 = 380;
ypos_row1 = 55;

dist_y = -10;
dist_y_bottom = 18;
dist_x = 29;
font_size = 26;
text_xpos_a = xpos_col1 - dist_x;
text_ypos_a = ypos_row3 + size_y_axes + dist_y;
text_xpos_b = xpos_col2 - dist_x;
text_ypos_b = text_ypos_a;
text_xpos_c = text_xpos_a;
text_ypos_c = ypos_row2  + size_y_axes +  dist_y;
text_xpos_d = text_xpos_b;
text_ypos_d = text_ypos_c;
text_xpos_e = text_xpos_a;
text_ypos_e = ypos_row1  + size_y_axes +  dist_y;
text_xpos_f = text_xpos_b;
text_ypos_f = text_ypos_e;
text_xpos_struct = xpos_col1 + size_x_axes/2;
text_ypos_struct = ypos_row1 - dist_y_bottom;
text_xpos_alg = xpos_col2 + size_x_axes/2;
text_ypos_alg = ypos_row1 - dist_y_bottom;
% 
% 
%% create an axes: plot cpl
Res_cpl_x = xpos_col1;
Res_cpl_y = ypos_row1;
Res_cpl_size_x = size_x_axes;
Res_cpl_size_y = size_y_axes;
Res_cpl_pos = [Res_cpl_x Res_cpl_y Res_cpl_size_x Res_cpl_size_y];
ax1 = axes('Parent',f1,'Units','pixels','Position',Res_cpl_pos);
%plot_binary_directed();
%plot_weighted_undirected();
plot_weighted_directed();

% 
%% create an axes: plot clustering
Res_clust_x = xpos_col2;
Res_clust_y = ypos_row1;
Res_clust_size_x = size_x_axes;
Res_clust_size_y = size_y_axes;
Res_clust_pos = [Res_clust_x Res_clust_y Res_clust_size_x Res_clust_size_y];
ax2 = axes('Parent',f1,'Units','pixels','Position',Res_clust_pos);
%plot_binary_undirected();
plot_weighted_undirected();
%% create an axes: plot trans
Res_trans_x = xpos_col1;
Res_trans_y = ypos_row2;
Res_trans_size_x = size_x_axes;
Res_trans_size_y = size_y_axes;
Res_trans_pos = [Res_trans_x Res_trans_y Res_trans_size_x Res_trans_size_y];
ax3 = axes('Parent',f1,'Units','pixels','Position',Res_trans_pos);
plot_binary_directed();

%
%% create an axes: plot global efficiency
Res_ge_x = xpos_col2;
Res_ge_y = ypos_row2;
Res_ge_size_x = size_x_axes;
Res_ge_size_y = size_y_axes;
Res_ge_pos = [Res_ge_x Res_ge_y Res_ge_size_x Res_ge_size_y];
ax4 = axes('Parent',f1,'Units','pixels','Position',Res_ge_pos);
plot_binary_undirected();


ax_text_lengthx = .5;
ax_text_lengthy = .5;
ax_text = axes('Parent',f1,'Units','pixels','Position',[0 0 ax_text_lengthx ax_text_lengthy]);

hold on

 text(40, 950, ...
    '$\mathrm{(a)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
text(560, 950, ...
    '$\mathrm{(b)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
text(40, 465, ...
    '$\mathrm{(c)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
text(560, 465, ...
    '$\mathrm{(d)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
    
% text(x_end_value*0.75, 0.46, ...
%     '$\mathrm{BCT}$','Interpreter','latex',...
%     'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
% text(x_end_value*0.75, 0.41, ...
%     '$\mathrm{BCT}~\mathrm{edit}$','Interpreter','latex',...
%     'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
% text(x_end_value*0.75, 0.36, ...
%     '$\mathrm{BRAPH}$','Interpreter','latex',...
%     'HorizontalAlignment','left','VerticalAlignment','middle','FontSize',18)
