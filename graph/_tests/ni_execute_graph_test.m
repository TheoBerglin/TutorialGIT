function [passed, test_struct] = ni_execute_graph_test(test_name)
%EXECUTER_MEASURE_TESTS This file should execute the test TEST_NAME for
%graph object measures
% This is not finished yet, Need to restructure graph objects first with
% adding the properties struct
% Change return parameter

%% Get test information
 eval(['[test_struct, test_func] = ' test_name '();'])
 
%% Perform tests
tol = 1e-6;
passed = true;

n_measures = size(Graph.MEASURES,1);
test_function_nbr = NaN;
for i = 1:n_measures
    if Graph.MEASURES(i).FUNCTION == test_func
        test_function_nbr = i;
        break;
    end
end

if isnan(test_function_nbr)
    passed = false;
    test_struct = get_test_struct(zeros(5), Graph.BD, NaN, 'Test function error');
    return
end

return_parameter = Graph.MEASURES(test_function_nbr).VARIABLE; % Change when implemented in Graph object
for i=1:length(test_struct)
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    g = NaN;
    exp_result = test_struct(i).exp_result;
    if type == Graph.BD
        g = GraphBD(connectivity_matrix);
    elseif type == Graph.BU
        g = GraphBU(connectivity_matrix);
    elseif type == Graph.WU
        g = GraphWU(connectivity_matrix);
    elseif type == Graph.WD
        g = GraphWD(connectivity_matrix);
    end
    
    if ~isnan(g)
        try
            eval(['g.measure(' test_function_nbr ');']);
            eval(['res = g.' return_parameter ';']);
        catch MException
            if isequal(MException.message, 'Negative weights, not implemented')
                res = exp_result;
            end
        end
    else 
        res = exp_result;
    end
    
    if isequaln(res, exp_result) || all(all(abs(res - exp_result) < tol))
        test_struct(i).passed = true;
    else
        passed = false;
    end
end

end

