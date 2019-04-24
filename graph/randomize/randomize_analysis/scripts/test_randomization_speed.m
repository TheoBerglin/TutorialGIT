clear all, clc, close all
%% Settings
functions = {'randomize_braph_BD' 'randomize_braph_BU' 'randomize_combo_WD_fix' 'randomize_combo_WU_fix',...
    'randomize_bct_D' 'randomize_bct_U' 'randomize_bct_D' 'randomize_bct_U'};
type = {Graph.BD, Graph.BU, Graph.WD, Graph.WU, Graph.BD, Graph.BU, Graph.WD, Graph.WU};
densities = [0.0001];% 0.001 0.01]; % 0.05 0.1 %, 0.2 0.4 0.7];
small_size = [150 200 300 400];
large_size = [small_size, 800 1000 5000 10000 50000 100000];
size_vec = {large_size, large_size, large_size, large_size, small_size, small_size, small_size, small_size};
n_randomizations = 40;

%% Data path
current_loc = fileparts(which('test_randomization_speed.m'));
%% Save path and file save variables
% Names of folders for test functions
save_path = sprintf('%s%sspeed', current_loc, filesep); % data_path/function
exist_create_dir(save_path);
addpath(save_path);
%% Save file variables
file_name = 'speed.mat'; % tag_density.mat
save_file = sprintf('%s%s%s', save_path, filesep, file_name);
node_struct = struct('nodes', nan, 'density', nan, 'times', []);
%% Check if save file exist otherwise create the structure
if exist(save_file, 'file')
    l = load(save_file);
    speed_data = l.speed_data;
else
    type_struct = struct('directed', struct(), 'undirected', struct());
    speed_data = struct('weighted', type_struct, 'binary', type_struct);
end

for funci = 1:length(functions)
func = functions{funci};
dir = Graph.is_directed(type{funci});
wei = Graph.is_weighted(type{funci});

if wei
    wei_str = 'weighted';
else
    wei_str = 'binary';
end

if dir
    dir_str = 'directed';
else
    dir_str = 'undirected';
end

%% run randomization
fprintf('Running the randomization speed test for:\n %s\n', func);
for di = 1:length(densities)
    if ~isfield(speed_data.(wei_str).(dir_str), func)
        speed_data.(wei_str).(dir_str).(func) = node_struct;
        speed_ind = 1;
    else
        speed_ind = length(speed_data.(wei_str).(dir_str).(func))+1;
    end
    sizes = size_vec{funci};
    for si = 1:length(sizes)
        d = densities(di); % Density
        s = sizes(si); % Size of matrix2
        A = create_matrix(d*100, s, dir, wei);
        try
            times = zeros(1, n_randomizations);
            for i = 1:n_randomizations
                tic
                eval(sprintf('%s(A);', func))
                times(i) = toc;
            end
            speed_data.(wei_str).(dir_str).(func)(speed_ind) = struct('nodes', s, 'density', d, 'times', times);
            fprintf('Size: %d Density: %.4f Time per run: %.7f\n', s, d, mean(times))
        catch
            speed_data.(wei_str).(dir_str).(func)(speed_ind) = struct('nodes', nan, 'density', nan, 'times', times);
            fprintf('ERROROR: Size: %d Density: %.4f did not finish\n', s, d)
        end
        speed_ind = speed_ind+1;
    end
end

save(save_file, 'speed_data');
end
