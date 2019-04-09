function [p_values, fdr_res, failed_tests, ones_tests] = run_fdr(file_name, nodes_to_check, excl_ass, saveon, ploton)
%EXTRACT_FAILED_PERMUTATIONS Returns a struct containing failed test
%information. Input is a file name containing the data of interest.

if ~exist('excl_ass', 'var')
    excl_ass = false;
end
if ~exist('saveon', 'var')
    saveon = false;
end
if ~exist('ploton', 'var')
    ploton = false;
end

load(file_name)

C = strsplit(file_name, {'_', '.'});
file_name = strjoin(C(2:end-1),'_');

p_values = [];
if excl_ass
    measures_exclude = {'ass', 'deg', 'den', 'str', 'nr_e'};
else
    measures_exclude = {'deg', 'den', 'str', 'nr_e'};
end

for ni = 1:length(data)
    node_data = data(ni).node_data;
    nodes = data(ni).nodes;
    if any(nodes == nodes_to_check)
        for row = 1:length(node_data)  % loop through densities
            p_vals_all = node_data(row).p_value_vs_gt;
            fields = fieldnames(p_vals_all);
            for fi = 1:length(fields)  % loop through measures
                p_val = p_vals_all.(fields{fi});
                if ~any(strncmpi(fields{fi}, measures_exclude, 3))
                    if p_val == 0
                        f_struct = struct('nodes', nodes,'density',node_data(row).density,...
                            'weighted',node_data(row).weighted, ...
                            'directed',node_data(row).directed,...
                            'measure', fields{fi});
                        if ~exist('failed_tests', 'var')
                            failed_tests(1) = f_struct;
                        else
                            failed_tests(end+1) = f_struct;
                        end
                    elseif p_val == 1
                        f_struct = struct('nodes', nodes,'density',node_data(row).density,...
                            'weighted',node_data(row).weighted, ...
                            'directed',node_data(row).directed,...
                            'measure', fields{fi});
                        if ~exist('ones_tests', 'var')
                            ones_tests(1) = f_struct;
                        else
                            ones_tests(end+1) = f_struct;
                        end
                    end
                    if ~exist('p_values_node', 'var')
                        p_values_node(1) = p_val;
                    else
                        p_values_node(end+1) = p_val;
                    end
                end
            end
        end
        p_values = [p_values p_values_node];
    end
end

fdr_res = fdr(p_values);
if ploton
    x = 1:1:length(p_values);
    figure();
    plot(x, sort(p_values));
    hold on;
    plot(x, 0.05*x/length(p_values));
    legend('P-values', 'q*x', 'Location', 'best')
    if excl_ass
        str = sprintf('%s, relevant measures, ass excl, FDR: %.4f', file_name, fdr_res);
    else
        str = sprintf('%s, relevant measures, FDR: %.4f', file_name, fdr_res);
    end
    title(str)
    ylabel('P-value')
    xlabel('Number of samples')
    if saveon
        saveas(gcf, 'randomize/randomize_analysis/fdr/bu_rel-ass.png')
    end
end
end

