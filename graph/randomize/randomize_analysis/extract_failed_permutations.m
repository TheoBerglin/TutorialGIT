function failed_tests = extract_failed_permutations(file_name)
%EXTRACT_FAILED_PERMUTATIONS Returns a struct containing failed test
%information. Input is a file name containing the data of interest.
load(file_name)
for ni = 1:length(data)
    node_data = data(ni).node_data;
    nodes = data(ni).nodes;
    for row = 1:length(node_data)
        p_vals_all = node_data(row).p_value_vs_gt;
        fields = fieldnames(p_vals_all);
        for fi = 1:length(fields)
           p_vals = p_vals_all.(fields{fi});
           if length(p_vals) <= 1
              continue 
           end
           n_fails = fdr(p_vals);
           if n_fails >0
              f_struct = struct('nodes', nodes,'density',node_data(row).density,...
              'weighted',node_data(row).weighted, ...
              'directed',node_data(row).directed,...
              'measure', fields{fi}, ...
              'fail_rate', n_fails); 
              if ~exist('failed_tests', 'var')
                  failed_tests(1) = f_struct;
              else
                  failed_tests(end+1) = f_struct;
              end
           end
        end        
    end    
end
end

