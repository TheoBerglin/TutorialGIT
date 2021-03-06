function [passed, test_struct] = execute_graph_measure_test(test_name)
%EXECUTE_GRAPH_MEASURE_TEST This file should execute the test TEST_NAME for
%graph object measures

%% Get test information
eval(['[test_struct, test_func] = ' test_name '();'])

%% Perform tests
tol = 1e-6;
passed = true;
gd = GraphBD(zeros(5));
n_measures = size(gd.MS,2);
test_function_nbr = NaN;
for i = 1:n_measures
    if isequal(gd.MS{i}.FUNCTION, test_func)
        test_function_nbr = i;
        break;
    end
end

if isnan(test_function_nbr)
    passed = false;
    test_struct = get_test_struct(zeros(5), Graph.BD, NaN, sprintf('Test function error %s', test_func));
    return
end
for i=1:length(test_struct)
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    g = [];
    exp_result = test_struct(i).exp_result;
    cs = test_struct(i).community_structure;
    
    if isempty(cs)
        if type == Graph.BD
            g = GraphBD(connectivity_matrix);
        elseif type == Graph.BU
            g = GraphBU(connectivity_matrix);
        elseif type == Graph.WU
            g = GraphWU(connectivity_matrix);
        elseif type == Graph.WD
            g = GraphWD(connectivity_matrix);
        end
    else
        structure = Structure('Ci', cs, 'algorithm', 'fixed');
        if type == Graph.BD
            g = GraphBD(connectivity_matrix,'structure', structure);
        elseif type == Graph.BU
            g = GraphBU(connectivity_matrix,'structure', structure);
        elseif type == Graph.WU
            g = GraphWU(connectivity_matrix,'structure', structure);
        elseif type == Graph.WD
            g = GraphWD(connectivity_matrix,'structure', structure);
        end
    end
    
    if ~isempty(g)
        try
            eval(sprintf( 'g.calculate_measure(%d);', test_function_nbr) );
            eval(sprintf('res = g.MS{%d}.VALUE;', test_function_nbr));
        catch MException
            if isequal(MException.message, 'Negative weights, not implemented')
                res = exp_result;
            end
            res = exp_result-1;
        end
    else
        res = exp_result;
    end
    
    comparison = res - exp_result;
    if isequaln(res, exp_result) || all(all(abs(comparison(~isnan(comparison))) < tol))
        test_struct(i).passed = true;
    else
        passed = false;
    end
end

end

