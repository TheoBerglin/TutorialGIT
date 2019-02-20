function test_struct = get_test_struct(connectivity, type, exp_result, name, community_structure)
% GET_TEST_STRUCT A structure containing information needed for a test

% TEST_STRUCT = GET_TEST_STRUCT(C0NNECTIVITY, TYPE, EXPRESULT, NAME, COMMUNITY_STRUCTURE) 
%   Given the properties the function returns a struct of the parameters.
%   CONNECTIVITY is the graph for which the test should be carried out on
%   and TYPE being the type of graph. EXPRESULT is the expected result.
%   NAME is the name of the test. COMMUNITY_STRUCTURE is an optional
%   parameter that contains a community structure corresponding to the
%   connectivity matrix.

if nargin == 4  % no community structure passed
    community_structure = [];
end

test_struct = struct('connectivity', connectivity, 'type', type, ...
    'exp_result', exp_result, 'name', name, 'community_structure',...
    community_structure, 'passed', false);
end

