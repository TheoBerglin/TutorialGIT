clear all, close all, clc
%% Settings
original_path = fileparts(which('test_randomization.m'));
data_path = path_append(original_path, 'data');
save_path =  path_append(original_path, 'validation_saves');
exist_create_dir(save_path);
node_folders = get_sub_folders(data_path);
for nodi = 1: length(node_folders)
    if isequal(node_folders{nodi}, 'speed')
        continue
    end
    node_path = path_append(data_path, node_folders{nodi});
    analysis_folders = get_sub_folders(node_path);
    for foli = 1:length(analysis_folders)
        folder = analysis_folders{foli};
        folder_path = path_append(node_path, folder);
        valid_folder = path_append(folder_path, 'validation');
        exist_create_dir(valid_folder);
        addpath(valid_folder);
        if isequal(folder, 'speed')
            continue
        end
        dir = contains(folder, '_bd') || contains(folder, '_D') || contains(folder, '_WD');
        save_path_method = path_append(save_path, node_folders{nodi});
        exist_create_dir(save_path_method);
        addpath(save_path_method)
        save_path_method = path_append(save_path_method, folder);
        exist_create_dir(save_path_method);
        addpath(save_path_method)
        [seperated.binary, seperated.weighted] = get_valid_data(valid_folder);
        seperated_fields = fieldnames(seperated);
        fprintf('Running analysis for method %s\n', folder)
        for d = 1 : length(seperated_fields)
            data_type = seperated_fields{d};
            data = seperated.(data_type);
            if isempty(data)
                continue
            end
            [test_data, failed_tests] = get_failed_tests(data);
            table = get_table(failed_tests, test_data);
            table_to_tex(table, save_path_method,folder, data_type);
            fprintf('Plotting for %s\n', data_type);
            plot_failed_distributions(test_data, save_path_method, data_type, dir);
        end
    end
end
disp('DONE!')

function plot_failed_distributions(test_data, save_path, data_type, dir)
if dir
    dir_str = 'directed';
else
    dir_str = 'undirected';
end
for i = 1:length(test_data)
    dens = test_data(i).density;
    failed_test_data = test_data(i).failed_tests;
    failed_test_names = fieldnames(failed_test_data);
    % Loop through failed tests
    for j = 1:length(failed_test_names)
        measure_name = get_measure_name(failed_test_names{j});
        failed = failed_test_data.(failed_test_names{j});
        try
            plot_distributions(failed.dist1, failed.dist2);
            f = openfig('temp_name.fig');
            legend('Ground truth', 'Ground truth fit', 'Function', 'Function fit', 'Location', 'best')
            title(sprintf('%s for %s and %s graph', measure_name, data_type, dir_str))
            file_name = sprintf('%s_%s_dens_%d_%s.jpg', data_type, dir_str, dens,failed_test_names{j});
            print(f, [save_path filesep file_name],'-dpng','-r300');
            close all;
        catch
            disp(['Could not plot: ' measure_name])
        end
    end
    
end
end

function measure_name = get_measure_name(meas_short)
measures = {'Validate randomization',...
    'In-in assortativity',...
    'In-out Assortativity',...
    'Out-in Assortativity',...
    'Out-out Assortativity',...
    'Characteristic pathlength wsg',...
    'Characteristic in-pathlength wsg',...
    'Caracteristic out-pathlength wsg',...
    'Clustering global',...
    'Degree',...
    'In-degree',...
    'Out-Degree',...
    'Density',...
    'Diameter',...
    'In-diameter',...
    'Out-diameter',...
    'Eccentricity',...
    'In-eccentricity',...
    'Out-eccentricity',...
    'Global efficiency',...
    'In-global efficiency',...
    'Out-global efficiency',...
    'Local efficiency',...
    'Radius',...
    'In-radius',...
    'Out-Radius',...
    'Strength',...
    'In-strength',...
    'Out-strength'};
out_var = {'nr_edges',...
    'ass_in_in',...
    'ass_in_out',...
    'ass_out_in',...
    'ass_out_out',...
    'cpl_wsg',...
    'cpl_wsg_in',...
    'cpl_wsg_out',...
    'clustering_global',...
    'degree_av',...
    'degree_in_av',...
    'degree_out_av',...
    'density',...
    'diameter',...
    'diameter_in',...
    'diameter_out',...
    'ecc_av',...
    'ecc_in_av',...
    'ecc_out_av',...
    'gleff_av',...
    'gleff_in_av',...
    'gleff_out_av',...
    'leff_av',...
    'radius',...
    'radius_in',...
    'radius_ou',...
    'str_av',...
    'str_in_av',...
    'str_out_av'};
possible_indices = find(contains(out_var, meas_short));
for i = length(possible_indices)
    if isequal(out_var{possible_indices(i)}, meas_short)
        measure_name = measures{possible_indices(i)};
        return
    end
end
measure_name = 'NoName';
end
function table_to_tex(table, save_path, folder, data_type)
% \begin{table}[]
%     \centering
%     \begin{tabular}{c|c}
%          &  \\
%          &
%     \end{tabular}
%     \caption{Caption}
%     \label{tab:my_label}
% \end{table}
table_txt = '\\begin{table}[h] \\centering \\begin{tabular}{%s} \\hline\\multicolumn{1}{|c|}{\\textbf{\\large{Function}}} & \\multicolumn{17}{c|}{\\large{\\textbf{Density [percent]]}}}\\\\\\cline{2-18}';
table_end = ['\end{tabular}\caption{' replace(folder, '_', '\_') ' ' data_type '}\label{tab:my_label} \end{table}'];
functions = fieldnames(table);
header = [table(:).dens];
n_header = length(header);
structure = '|l|';

for i = 1:n_header
    structure = sprintf('%sc|', structure);
end
n_rows = length(functions);
table_txt = sprintf(table_txt, structure );
% Fill header
row = ' &';
for c = 1:n_header-1
    row =sprintf('%s \\textbf{%d} & ',row,header(c));
end
row = sprintf('%s \\textbf{%d} \\\\ \\hline ',row,header(c+1));
table_txt = sprintf('%s %s', table_txt, row);
% Fill rows
for r = 2:n_rows
    row_vals = [table(:).(functions{r})];
    row = '';
    row = sprintf('%s \\textit{%s} &', row, replace(functions{r}, '_', '\_'));
    for c = 1:length(row_vals)-1
        if row_vals(c)
            str_tmp = 'X';
        else
            str_tmp = ' ';
        end
        row = sprintf('%s %s &', row, str_tmp);
    end
    if  row_vals(length(row_vals))
        str_tmp = 'X';
    else
        str_tmp = ' ';
    end
    row = sprintf('%s %s \\\\ \\hline', row, str_tmp);
    table_txt = sprintf('%s %s', table_txt, row);
end
table_txt = sprintf('%s %s', table_txt, table_end);
fid = fopen([save_path filesep folder '_' data_type '_table.tex'],'w');
%fid = fopen(sprintf('%s%stable.txt', save_path, filesep),'w');
fprintf(fid, replace(table_txt, '\', '\\'));
fclose(fid);

end

function table = get_table(faild_test_cell, test_data)
densities = [test_data(:).density];
[densities, o_ind] = sort(densities);
faild_test_cell = sort(faild_test_cell);
struct_str = '''dens'', NaN';
for i=1:length(faild_test_cell)
    struct_str = sprintf('%s, ''%s'', false', struct_str, faild_test_cell{i});
end
n = length(densities);
% Create base of table
eval(sprintf('table = repmat(struct(%s), [n, 1]);', struct_str));
% Fill table
for i = 1:n
    dens = densities(i);
    table(i).dens = dens;
    ft = test_data(o_ind(i)).failed_tests;
    ft = fieldnames(ft);
    for j = 1:length(ft)
        t = ft(j);
        table(i).(t{1}) = true;
    end
end


end

function [test_data, failed_tests] = get_failed_tests(data)
n_files = length(data);
%failed_struct = struct('d1', NaN, 'd2', NaN);
%'name', 'NO_NAME','data', failed_struct)
data_struct = struct('density', 0, 'failed_tests', struct());
test_data = struct(repmat(data_struct, [1 n_files]));
failed_tests = {};
for fi = 1 : n_files
    f = data{fi};
    load(f);
    dens = extract_density(f);
    test_data(fi).density = dens;
    if n_eq_dist == n_meas
        continue
    end
    failed_ind = 1;
    meas_names = fieldnames(valid);
    for mi = 1 : length(meas_names)
        meas = meas_names{mi};
        if ~valid.(meas).equal
            
            ok = true;
            indices = find(contains(failed_tests, meas));
            for i = 1:length(indices)
                if isequal(failed_tests{indices(i)}, meas)
                    ok = false;
                end
            end
            %if all(~isequal(failed_tests, meas))
            if ok
                failed_tests{end+1} = meas;
            end
            
            try
                test_data(fi).failed_tests.(meas) =  struct('dist1', valid.(meas).dist1, 'dist2', valid.(meas).dist2);
            catch
                test_data(fi).failed_tests.(meas) =  struct('dist1', [], 'dist2', []);
            end
            %test_data(fi).failed_tests.(failed_ind).dist1 = valid.(meas).dist1;
            %test_data(fi).failed_tests.(meas).dist2 = valid.(meas).dist2;
            failed_ind = failed_ind +1;
        end
    end
end
end

function dens = extract_density(file_name)
if ~contains(file_name, 'dens')
    dens = NaN;
    return
end
split1 = strsplit(file_name, 'dens_');
split2 = strsplit(split1{2}, '_');
dens = round(str2double(split2{1}));
end
function [binary, weighted] = get_valid_data(folder_path)
f = get_files(folder_path);
f = get_valid_files(f);
n_binary = 1;
n_weighted = 1;
binary = {};
weighted = {};
for i = 1:length(f)
    if contains(f{i}, '_bin_')
        binary{1,n_binary} = f{i};
        n_binary = n_binary + 1;
    else
        weighted{n_weighted} = f{i};
        n_weighted = n_weighted + 1;
    end
end
end

function f_valid = get_valid_files(f)
n_files = 1;
f_valid = {};
for i = 1:length(f)
    if contains(f{i}, 'valid')
        f_valid{n_files} = f{i};
        n_files = n_files + 1;
    end
end
end
function p = path_append(p, extend)
if ~iscell(extend)
    extend = {extend};
end
for i = 1:length(extend)
    p = sprintf('%s%s%s',p, filesep, extend{i});
end

end
function f = get_files(directory)
files = dir(directory);
fileFlag = ~[files.isdir];
files = files(fileFlag);
f = {files(:).name};
end
function subFolders = get_sub_folders(directory)
files = dir(directory);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
subFolders = {subFolders(3:end).name}; % First 2 are '.' and '..'
end