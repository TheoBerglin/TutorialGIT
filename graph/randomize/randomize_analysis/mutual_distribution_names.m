clear all, close all, clc;
%% Rename all graphs according to one standard
%% Extract all data
all_data = struct();
data_names = {'distribution_data_even_iterations' 'distribution_data_odd_max_att' 'distribution_data_one_run'};
dist_data_str = {'dist_data_even_iterations' 'dist_data_odd_max_att' 'dist_data'};
for i = 1:length(data_names)
   d = load(sprintf('%s.mat', data_names{i}));
   all_data.(data_names{i}) = d.(dist_data_str{i});
end
%% Extract names
ind = 1;
names = extractfield(all_data.distribution_data_even_iterations.node_4.randmio_dir_signed_edit_low_attempts, 'name');
mats = {};
for i = 1:length(names)
    mats{i} = all_data.distribution_data_even_iterations.node_4.randmio_dir_signed_edit_low_attempts(i).org;
end
%mats = extractfield(all_data.distribution_data_even_iterations.node_4.randmio_dir_signed_edit_low_attempts, 'org');
%% Set new names
run_fields = fieldnames(all_data);
for ri = 1:length(run_fields)
    node_fields = fieldnames(all_data.(run_fields{ri}));
    for ni = 1:length(node_fields)
        method_fields = fieldnames(all_data.(run_fields{ri}).(node_fields{ni}));
        for mi = 1: length(method_fields)
            org_mat = all_data.(run_fields{ri}).(node_fields{ni}).(method_fields{mi})(mi).org;
            name = 'unknown';
            for namei = 1:length(names)
                if all(all(org_mat == mats{namei}))
                    name = names{namei};
                    break
                end                
            end
            all_data.(run_fields{ri}).(node_fields{ni}).(method_fields{mi})(mi).name = name;
            
        end
    end
end

save('distribution_all_data_mutual_names.mat', 'all_data')