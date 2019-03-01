function test_struct = get_test_struct(connectivity, type, exp_result, name, varargin)
% GET_TEST_STRUCT A structure containing information needed for a test

% TEST_STRUCT = GET_TEST_STRUCT(C0NNECTIVITY, TYPE, EXPRESULT, NAME, VARARGIN)
%   Given the properties the function returns a struct of the parameters.
%   CONNECTIVITY is the graph for which the test should be carried out on
%   and TYPE being the type of graph. EXPRESULT is the expected result.
%   NAME is the name of the test. VARARGIN are optional parameters and can be
%       COMMUNITY_STRUCTURE - contains a community structure corresponding
%                             to the connectivity matrix.
%       NODES               - nodes to remove in case of nodeattack
%       NODES_FROM          - start node of edges to remove in case of edgeattack
%       NODES_TO            - end node of edges to remove in case of edgeattack

community_structure = [];
nodes = [];
nodes_from = [];
nodes_to = [];

for n = 1:1:length(varargin)-1
    if strcmpi(varargin{n},'community_structure')
        community_structure = varargin{n+1};
    elseif strcmpi(varargin{n},'nodes')
        nodes = varargin{n+1};
    elseif strcmpi(varargin{n},'nodes_from')
        nodes_from = varargin{n+1};
    elseif strcmpi(varargin{n},'nodes_to')
        nodes_to = varargin{n+1};
    end
end

test_struct = struct('connectivity', connectivity, 'type', type, ...
    'exp_result', exp_result, 'name', name, 'community_structure',...
    community_structure, 'nodes', nodes, 'nodes_from', nodes_from,...
    'nodes_to', nodes_to, 'passed', false);
end

