clear all, clc, close all
%% Settings
func = 'randomize_bct_D';
densities = [0.01 0.1 0.2 0.5 0.7];%[0.01 0.02 0.03 0.04 0.05 0.1, 0.2 0.3 0.4 0.5 0.6 0.7];
sizes = [50 60 100 150 200]; % 400 800];% 1000 2000];
n_randomizations = 40;
dir = true;
wei = false;
%% Data path
current_loc = fileparts(which('test_randomization.m'));
data_path = sprintf('%s%s%s', current_loc, filesep, 'data');
exist_create_dir(data_path);
addpath(data_path);
%% Save path and file save variables
% Names of folders for test functions
save_path = sprintf('%s%sspeed', data_path, filesep); % data_path/function
exist_create_dir(save_path);
addpath(save_path);
%% Save file variables
file_name = sprintf('speed_%s.mat', func); % tag_density.mat
save_file = sprintf('%s%s%s', save_path, filesep, file_name);
%% Check if save file exist otherwise create the structure
if exist(save_file, 'file')
    l = load(save_file);
    speed_data = l.speed_data;
    speed_ind = length(speed_data) + 1;
else
    speed_ind = 1;
end
%% run randomization
fprintf('Running the randomization speed test for:\n %s\n', func);
for di = 1:length(densities)
    for si = 1:length(sizes)
        d = densities(di); % Density
        s = sizes(si); % Size of matrix
        time = 0;
        A = create_matrix(d, s, dir, wei);
        for i = 1:n_randomizations
            tic
            eval(sprintf('%s(A);', func))
            time = time + toc;
        end
        speed_data(speed_ind) = struct('size', s, 'density', d,...
            'n_randomizations', n_randomizations, 'time', time/n_randomizations, ...
            'weighted', wei, 'directed', dir);
        fprintf('Size: %d Density: %.2f Time per run: %.7f\n', s, d, time/n_randomizations)
        speed_ind = speed_ind + 1;
    end
end

save(save_file, 'speed_data');

function A = create_matrix(d, s, dir, wei)
edges = s*s;
indizes = randperm(edges, round(edges*d));
A = zeros(s, s);
A(indizes) = 1;

%% Binary/weight settings
if wei
    W = rand(nodes);
    A = A.*W;
end

%% Directed/undirected settings
if ~dir
    %Symmetrize if undirected
    A = triu(A);
    A = A+A.';
end
A = replace_diagonal(A, 1);

end