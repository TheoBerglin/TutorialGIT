clc, clear all, clf, close all;

% Data for BU, size: 200, dens:0.01

f1 = figure();
set(f1,'Color','w','Position',[100 40 1400 730])
%% global parameters
size_x_axes = 250;
size_y_axes = 250;
% 
xpos_col1 = 55;
xpos_col2 = 500;
xpos_col3 = 950;

ypos_row3 = 540;
ypos_row1 = 380;
ypos_row2 = 55;

dist_y = -10;
dist_y_bottom = 18;
dist_x = 29;
dist_x_snd_col = 40;
font_size = 26;
text_xpos_a = xpos_col1 - dist_x;
text_ypos_a = ypos_row1 + size_y_axes + dist_y;
text_xpos_b = xpos_col2 - dist_x_snd_col;
text_ypos_b = text_ypos_a;
text_xpos_c = xpos_col3 - dist_x_snd_col;
text_ypos_c = text_ypos_a;
text_xpos_d = text_xpos_a;
text_ypos_d = ypos_row2  + size_y_axes +  dist_y;   
text_xpos_e = text_xpos_b;
text_ypos_e = text_ypos_d;
text_xpos_f = text_xpos_c;
text_ypos_f = text_ypos_d;
text_xpos_struct = xpos_col1 + size_x_axes/2;
text_ypos_struct = ypos_row2 - dist_y_bottom;
text_xpos_alg = xpos_col2 + size_x_axes/2;
text_ypos_alg = ypos_row2 - dist_y_bottom;
% 
% 
%% create an axes: plot degree bu
Res_deg_bu_x = xpos_col1;
Res_deg_bu_y = ypos_row1;
Res_deg_bu_size_x = size_x_axes;
Res_deg_bu_size_y = size_y_axes;
Res_deg_bu_pos = [Res_deg_bu_x Res_deg_bu_y Res_deg_bu_size_x Res_deg_bu_size_y];
ax1 = axes('Parent',f1,'Units','pixels','Position',Res_deg_bu_pos);
plot_deg_bu();

%% create an axes: plot fdr bu
Res_fdr_x = xpos_col3;
Res_fdr_y = ypos_row1;
Res_fdr_size_x = size_x_axes;
Res_fdr_size_y = size_y_axes;
Res_fdr_pos = [Res_fdr_x Res_fdr_y Res_fdr_size_x Res_fdr_size_y];
ax2 = axes('Parent',f1,'Units','pixels','Position',Res_fdr_pos);
plot_fdr_bu();

%% create an axes: plot degree wu
Res_deg_bd_x = xpos_col1;
Res_deg_bd_y = ypos_row2;
Res_deg_bd_size_x = size_x_axes;
Res_deg_bd_size_y = size_y_axes;
Res_deg_bd_pos = [Res_deg_bd_x Res_deg_bd_y Res_deg_bd_size_x Res_deg_bd_size_y];
ax3 = axes('Parent',f1,'Units','pixels','Position',Res_deg_bd_pos);
plot_deg_wu();


%% create an axes: plot weights wu
Res_deg_bd_x = xpos_col2;
Res_deg_bd_y = ypos_row2;
Res_deg_bd_size_x = size_x_axes;
Res_deg_bd_size_y = size_y_axes;
Res_deg_bd_pos = [Res_deg_bd_x Res_deg_bd_y Res_deg_bd_size_x Res_deg_bd_size_y];
ax4 = axes('Parent',f1,'Units','pixels','Position',Res_deg_bd_pos);
plot_wei_wu();


%% create an axes: plot fdr wu
Res_deg_bd_x = xpos_col3;
Res_deg_bd_y = ypos_row2;
Res_deg_bd_size_x = size_x_axes;
Res_deg_bd_size_y = size_y_axes;
Res_deg_bd_pos = [Res_deg_bd_x Res_deg_bd_y Res_deg_bd_size_x Res_deg_bd_size_y];
ax5 = axes('Parent',f1,'Units','pixels','Position',Res_deg_bd_pos);
plot_fdr_wu();


ax_text_lengthx = .5;
ax_text_lengthy = .5;
ax_text = axes('Parent',f1,'Units','pixels','Position',[0 0 ax_text_lengthx ax_text_lengthy]);

hold on

text(text_xpos_a, text_ypos_a, ...
    '$\mathrm{(a)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
% text(text_xpos_b, text_ypos_b, ...
%     '$\mathrm{(b)}$','Interpreter','latex',...
%     'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
text(text_xpos_c, text_ypos_c, ...
    '$\mathrm{(b)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
text(text_xpos_d, text_ypos_d, ...
    '$\mathrm{(c)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
text(text_xpos_e, text_ypos_e, ...
    '$\mathrm{(d)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)
text(text_xpos_f, text_ypos_f, ...
    '$\mathrm{(e)}$','Interpreter','latex',...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',font_size)

