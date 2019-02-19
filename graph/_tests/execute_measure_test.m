function [passed, test_struct] = execute_measure_test(test_name)
%EXECUTER_MEASURE_TESTS This file should execute the test TEST_NAME for
%graph measures

%% Get test information
 eval(['[test_struct, test_func] = ' test_name '();'])
 
%% Perform tests
tol = 1e-6;
passed = true;
for i=1:length(test_struct)
    connectivity_matrix = test_struct(i).connectivity;
    type = test_struct(i).type;
    exp_result = test_struct(i).exp_result;
    
    try
        eval(['res=' test_func '(connectivity_matrix, type);']);
    catch MException
        if isequal(MException.message, 'Negative weights, not implemented')
            res = exp_result;
        end
    end
    
    if isequaln(res, exp_result) || all(all(abs(res - exp_result) < tol))
        test_struct(i).passed = true;
    else
        passed = false;
    end
end

end

