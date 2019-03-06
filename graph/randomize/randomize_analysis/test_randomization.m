%This file tests two randomization functions
clear all, clc, close all;
%% Settings
test_func_1 = 'randomize_braph_BU'; % Ground truth function
test_func_2 = 'randomize_braph_BU'; % New function
A = load('dens_0.200_nodes_100_bin_undir.txt');
matrix_tag = 'known_dens_0.200'; % Could be used to load Ground truth distributions and good for saving
n_randomizations = 100;
type = Graph.BD; % Graph type for the global measures
%save_file_ending = '.mat';
alpha = 0.05; %Confidence level Kolmogorov-Smirnov test
%% Data path
current_loc = fileparts(which('test_randomization.m'));
data_path = sprintf('%s%s%s', current_loc, filesep, 'data');
exist_create_dir(data_path);
addpath(data_path);
%% Save path and file save variables
% Names of folders for test functions
dens = density(A); % Could be used instead of matrix tag or to complement matrix tag
save_path_1 = sprintf('%s%s%s', data_path, filesep, test_func_1); % data_path/function
exist_create_dir(save_path_1);
addpath(save_path_1);
save_path_2 = sprintf('%s%s%s', data_path, filesep, test_func_2); % data_path/function
exist_create_dir(save_path_2);
addpath(save_path_2);
file_name = sprintf('%s_dens_%d.mat', matrix_tag, dens); % tag_density.mat
%% Save file variables
save_file_1 = sprintf('%s%s%s', save_path_1, filesep, file_name); 
save_file_2 = sprintf('%s%s%s', save_path_2, filesep, file_name);
%% Validation variable
% tag_density_func1_func2.mat
validation_name = sprintf('valid_%s_dens_%d_%s_%s.mat', matrix_tag, dens, test_func_1, test_func_2);
% save only to the new randomize directory. Ground truth will become messy
% otherwise
validation_file = sprintf('%s%s%s', save_path_2, filesep, validation_name);
%% Check if ground truth data available
if exist(save_file_1, 'file') % Ground truth available
    d = load(save_file_1);
    gm_list_1 = d.gm_list_1;
else % Ground truth doesn't exist
    gm_list_1 = run_randomization(A, type, test_func_1, n_randomizations);
    save(save_file_1, 'gm_list_1'); % Save ground truth
end
%% Run new randomization function
gm_list_2 = run_randomization(A, type, test_func_2, n_randomizations);
%% Extract validation information
[valid, n_eq_dist, n_meas] = run_validation(gm_list_1, gm_list_2, alpha);
%% Save validation matrix
save(validation_file, 'valid', 'n_eq_dist', 'n_meas');
fprintf('Number of equal distributions: %d\nTotalt tested distributions: %d\n', n_eq_dist, n_meas)
disp('done')
%% TODO: Add some validation analysis/print
function exist_create_dir(d)
if ~exist(d, 'dir')
    mkdir(d)
end
end