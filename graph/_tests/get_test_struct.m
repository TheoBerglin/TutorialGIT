function test_struct = get_test_struct(connectivity, type, exp_result, name)
% GET_TEST_STRUCT A structure containing information needed for a test

% TEST_STRUCT = GET_TEST_STRUCT(C0NNECTIVITY, TYPE, EXPRESULT, NAME) Given
% the properties the function returns a struct of the parameters.
% CONNECTIVITY is the graph for which the test should be carried out on
% and TYPE being the type of graph. EXPRESULT is the expected result.
% NAME is the name of the test.

test_struct = struct('connectivity', connectivity, 'type', type, ...
    'exp_result', exp_result, 'name', name, 'passed', false);
end

