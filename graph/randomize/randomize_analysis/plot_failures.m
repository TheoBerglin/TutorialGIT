clear all, close all, clc
%% Load data
load('till_theo.mat')

for i = 1:length(final)
    if ~contains(final(i).measure, 'ass_out_in')
        continue
    end
    if final(i).weighted && final(i).directed
        g_type = Graph.WD;
    elseif final(i).weighted && ~final(i).directed
        g_type = Graph.WU;
    elseif ~final(i).weighted && final(i).directed
        g_type = Graph.BD;
    else
        g_type = Graph.BU;
    end
    if ~final(i).directed 
        if contains(final(i).measure, 'in') || contains(final(i).measure, 'out')
            continue
        end
    end
    fprintf('Running for measure: %s\n', final(i).measure);
    plot_compare_measure_distributions(final(i).density,final(i).measure, final(i).nodes, g_type);
    disp('------------------------------------------')
end