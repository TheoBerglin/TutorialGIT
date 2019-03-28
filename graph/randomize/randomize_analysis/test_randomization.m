%This file tests two randomization functions
clear all, clc, close all;
%% Settings
test_func_1_array = {'randomize_bct_U' 'randomize_bct_U' 'randomize_bct_D' 'randomize_bct_D'};
test_func_2_array = {'randomize_bct_U' 'randomize_bct_U' 'randomize_bct_D' 'randomize_bct_D'};
type_array = {Graph.BU Graph.WU Graph.BD Graph.WD};
densities = [0.010 0.020 0.030 0.040 0.050 0.060 0.070 0.080 0.090 0.100 0.150 0.200 0.300 0.400 0.500 0.600 0.700];
nodes = 10;
n_randomizations = 10;
alpha = 0.05; %Confidence level Kolmogorov-Smirnov test
load_gt = true; % Do we want to load ground truth or calculate new
load_matrix = false;  % whether to load existing matrix or create a new
for runi = 1: length(test_func_1_array)
    test_func_1 = test_func_1_array{runi}; % Ground truth function
    test_func_2 = test_func_2_array{runi}; % New function
    type = type_array{runi}; % Graph type for the global measures
    %save_file_ending = '.mat';
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
    nodes_folder = sprintf('nodes_%d', nodes);
    disp('----------------------------------------------------')
    fprintf('Running test for methods\n %s\n %s\n',test_func_1, test_func_2);
    for i = 1:length(densities)
        dens = densities(i);
        disp('----------------------------------------------------')
        fprintf('Running test for density: %.3f\n', dens)
        %% Load matrix data
        if load_matrix
            load_file = sprintf('dens_%s_nodes_%d_%s_%s.txt', num2str(dens, '%.3f'), nodes, type_bin, type_dir);  %
            A = load(load_file);
        else
            A = create_matrix(dens, nodes, dir, wei);
        end
        dens = density(A); % Could be used instead of matrix tag or to complement matrix tag
        fprintf('Actual matrix density is: %.4f\n', dens/100);
        %% Data path for saving
        current_loc = fileparts(which('test_randomization.m'));
        data_path = sprintf('%s%s%s', current_loc, filesep, 'data');
        exist_create_dir(data_path);
        addpath(data_path);
        %% Node specific folder
        data_path = sprintf('%s%s%s', data_path, filesep, nodes_folder);
        exist_create_dir(data_path);
        addpath(data_path);
        %% Save path and file save variables
        % Names of folders for test functions
        %% GT folder
        save_path_1 = sprintf('%s%s%s', data_path, filesep, test_func_1); % data_path/function
        exist_create_dir(save_path_1);
        addpath(save_path_1);
        save_path_1 = sprintf('%s%s%s', save_path_1, filesep, 'GT'); % data_path/function
        exist_create_dir(save_path_1);
        addpath(save_path_1);
        
        %% Valdiation folder
        save_path_2 = sprintf('%s%s%s', data_path, filesep, test_func_2); % data_path/function
        exist_create_dir(save_path_2);
        addpath(save_path_2);
        save_path_2 = sprintf('%s%s%s', save_path_2, filesep, 'Validation'); % data_path/function
        exist_create_dir(save_path_2);
        addpath(save_path_2);
        %% File names
        GT_file_name = sprintf('GT_nodes_%d_dens_%.2f_%s_%s.mat', nodes, dens, type_bin, type_dir);
        validation_name = sprintf('valid_nodes_%d_dens_%.2f_%s_%s_%s.mat', nodes, dens, type_bin, test_func_1, test_func_2);
        
        %% Save file variable
        save_file_1 = sprintf('%s%s%s', save_path_1, filesep, GT_file_name); % Ground truth data        
        validation_file = sprintf('%s%s%s%s%s', save_path_2, filesep, validation_name); % Validation files
        
        %% Check if ground truth data available
        if exist(save_file_1, 'file') % Ground truth available
            d = load(save_file_1);
            gm_list_1 = d.gm_list_1;
            if length(gm_list_1) ~= n_randomizations % Not the correct size, rerun
                disp('GT not correct size, re-run GT')
                gm_list_1 = run_randomization(A, type, test_func_1, n_randomizations);
                save(save_file_1, 'gm_list_1'); % Save ground truth
            end
        else
            disp('GT not loaded')
            gm_list_1 = run_randomization(A, type, test_func_1, n_randomizations);
            save(save_file_1, 'gm_list_1'); % Save ground truth
        end
        %% Run new randomization function
        gm_list_2 = run_randomization(A, type, test_func_2, n_randomizations);
        %% Extract validation information
        [valid, n_eq_dist, n_meas] = run_validation(gm_list_1, gm_list_2, alpha);
        %% Save validation matrix
        save(validation_file, 'valid', 'n_eq_dist', 'n_meas');
        %% Ouput analysis details
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
    disp('Done with comparing the two methods')
    disp('----------------------------------------------------')
end
disp('Done with everything!')