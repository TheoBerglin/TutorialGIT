%This file tests two randomization functions
clear all, clc, close all;
%% Settings
test_func_1 = 'randomize_bct_D'; % Ground truth function
test_func_2 = 'randomize_bct_D'; % New function
%densities = [0.010 0.020 0.030 0.040 0.050 0.060 0.070 0.080 0.090 0.100 0.150 0.200 0.300];
densities = [0.4 0.5];
nodes = 100;
type = Graph.BD; % Graph type for the global measures
load_matrix = true;  % whether to load existing matrix or create a new
matrix_tag = 'known'; % Could be used to load Ground truth distributions and good for saving
n_randomizations = 100;
%save_file_ending = '.mat';
alpha = 0.05; %Confidence level Kolmogorov-Smirnov test
load_gt = true; % Do we want to load ground truth or calculate new
%%
for i = 1:length(densities)
    dens = densities(i);
    disp('----------------------------------------------------')
    fprintf('Running test for density: %.3f\n', dens)
    if Graph.is_binary(type)
        type_bin = 'bin';
        wei = false;
    else
        type_bin = 'wei';
        wei = true;
    end
    if Graph.is_directed(type)
        type_dir = 'dir';
        dir = true;
    else
        type_dir = 'undir';
        dir = false;
    end
    
    if load_matrix
        load_file = sprintf('dens_%s_nodes_%d_%s_%s.txt', num2str(dens, '%.3f'), nodes, type_bin, type_dir);
        A = load(load_file);
    else
        A = create_matrix(dens, nodes, dir, wei);
    end
    
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
    file_name = sprintf('%s_dens_%.2f.mat', matrix_tag, dens); % tag_density.mat
    
    %% Save file variables
    save_file_1 = sprintf('%s%s%s', save_path_1, filesep, file_name);
    save_file_2 = sprintf('%s%s%s', save_path_2, filesep, file_name);
    
    %% Validation variable
    % tag_density_func1_func2.mat
    validation_name = sprintf('valid_%s_dens_%.2f_%s_%s.mat', matrix_tag, dens, test_func_1, test_func_2);
    % save only to the new randomize directory. Ground truth will become messy
    % otherwise
    validation_file = sprintf('%s%s%s', save_path_2, filesep, validation_name);
    
    %% Check if ground truth data available
    if load_gt && exist(save_file_1, 'file') % Ground truth available
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
    if n_eq_dist ~= n_meas
        disp('Here follows the failed tests')
        fields = fieldnames(valid);
        for j = 1:length(fields)
            if valid.(fields{j}).equal == 0
                disp(fields{j})
            end
        end
    end
    disp('----------------------------------------------------')
    
end
disp('done')