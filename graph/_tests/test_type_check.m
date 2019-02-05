% File to test the static type checking methods.
%
% Author: Adam Liberda & Theo Berglin
% Date: 2019/02/04
% http://braph.org/

clear all, close all, clc
%% Directed check
method = {'is_directed', 'is_undirected', 'is_binary', 'is_weighted', 'is_positive', 'is_negative'};
type = {Graph.BD, Graph.BU, Graph.WD, Graph.WU, Graph.WDN, Graph.WUN};
type_str = {'Graph.BD', 'Graph.BU', 'Graph.WD', 'Graph.WU', 'Graph.WDN', 'Graph.WUN'};
exp_res = [true, false, true, false, true, false;
    false, true, false, true, false, true;
    true, true, false, false, false, false;
    false, false, true, true, true, true;
    true, true, true, true, false false;
    false, false, false, false, true, true];

for j=1:length(method)
    for i=1:length(type)
        res = eval(['Graph.', method{j},'(',int2str(type{i}),')']);
        if res == exp_res(j, i)
            fprintf('%s, %s - Passed\n', method{j}, type_str{i})
        else
            fprintf('%s, %s - Failed\n', method{j}, type_str{i})
        end
    end
end


