clear all, close all, clc;
%% Settings
file1 = 'speed_randomize_bct_D.mat';
file2 = 'speed_randomize_braph_BD.mat';
data_files = {file1, file2};
density = 0.1;

figure()
for i = 1:length(data_files)
    d = load(data_files{i});
    speed_data = d.speed_data;
    dens_data = extractfield(speed_data, 'density');
    indices = find(dens_data == density);
    time_data = extractfield(speed_data, 'time');
    time_data = time_data(indices);
    size_data = extractfield(speed_data, 'size');
    size_data = size_data(indices);
    name = replace(data_files{i}, 'speed_', '');
    name = replace(name, '_', '-');
    plot_data(i) = struct('name', name, 'size_data', size_data, 'time_data', time_data);
    loglog(plot_data(i).size_data, plot_data(i).time_data, 'DisplayName', plot_data(i).name)
    hold on
end

legend()
