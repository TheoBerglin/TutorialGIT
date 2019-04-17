%% Plot speed data
clear all, close all, clc;
%% Settings
run_all = -999;
sizes = [run_all];
densities = [0.01]; %All densities

%%
load('speed.mat');
type_bin_fields = fieldnames(speed_data);

plot_data = struct();

for bin_i = 1:length(type_bin_fields)
    plot_data.(type_bin_fields{bin_i}) = struct();
    type_dir_fields = fieldnames(speed_data.(type_bin_fields{bin_i}));
    for dir_i = 1:length(type_dir_fields)
        func_fields = fieldnames(speed_data.(type_bin_fields{bin_i}).(type_dir_fields{dir_i}));
        for func_i = 1:length(func_fields)
            density_data = extractfield(speed_data.(type_bin_fields{bin_i}).(type_dir_fields{dir_i}).(func_fields{func_i}), 'density');
            size_data = extractfield(speed_data.(type_bin_fields{bin_i}).(type_dir_fields{dir_i}).(func_fields{func_i}), 'nodes');
            indices = boolean(zeros(1, length(size_data)));
            % Extract indices for function
            for si = 1:length(sizes)
                if sizes(si) == run_all
                    size_ind = 1:length(size_data);
                else
                    size_ind = find(size_data == sizes(si));
                end
                for di = 1:length(densities)
                    if densities(di) == run_all
                        dens_ind = 1:length(size_data);
                    else
                        dens_ind = find(density_data == densities(di));
                    end
                    C = intersect(dens_ind, size_ind);
                    indices(C) = true;
                end
            end
            
            if contains(func_fields{func_i}, 'bct')
               method_name = 'BCT'; 
            else
                method_name = 'BRAPH';
            end
            method_name = sprintf('%s %s',method_name, type_dir_fields{dir_i});
            field_name = replace(method_name, ' ', '_');
            plot_data.(type_bin_fields{bin_i}).(field_name) = speed_data.(type_bin_fields{bin_i}).(type_dir_fields{dir_i}).(func_fields{func_i})(indices);
          %  plot_data.(type_bin_fields{bin_i}).(field_name).name = method_name;
            
        end
    end
end

%% Run this section seperate
% change these to select which plot
bin = 'binary';
%bin = 'weighted';
%plot_over = 'density';
plot_over = 'nodes';
data = plot_data.(bin);
fields = fieldnames(data);
figure()
for i = 1:length(fields)
    if length(data.(fields{i})) ==0
       continue 
    end
   x_data = extractfield(data.(fields{i}), plot_over);
   n = length(data.(fields{i}));
   y_data = zeros(1, n);
   for j = 1:n
      y_data(j) = min(data.(fields{i})(j).times);
   end
   loglog(x_data, y_data,'DisplayName', replace(fields{i}, '_', ' '))
   hold on
end
xlabel('Nodes')
ylabel('Time per randomization [s]')
title('Some title')
legend()
