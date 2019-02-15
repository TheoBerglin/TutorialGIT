function [ passed, details ] = test_type_check(  )
%TEST_TYPE_CHECK Test function for the type check methods
%
% Authors: Adam Liberda, Theo Berglin
% Date: 2019/02/11
% http://braph.org/

%% Test
method = {'is_directed', 'is_undirected', 'is_binary', 'is_weighted', 'is_positive', 'is_negative'};
type = {Graph.BD, GraphBU([]), GraphWD([]), Graph.WU, Graph.WDN, Graph.WUN};
exp_res = [true, false, true, false, true, false;
    false, true, false, true, false, true;
    true, true, false, false, false, false;
    false, false, true, true, true, true;
    true, true, true, true, false false;
    false, false, false, false, true, true];

passed = true;

for j=1:length(method)
    for i=1:length(type)
        arg = type{i};
        if isnumeric(arg)
            arg = int2str(arg);
            res = eval(['Graph.', method{j},'(', arg,')']);
        else
            res = eval(['Graph.', method{j},'(arg)']);
        end
            
        if res ~= exp_res(j, i)
            if passed
                details(1) = struct('name', method{j}, 'passed', false);
            else
                details(end+1) = struct('name', method{j}, 'passed', false);
            end
            passed = false;
        end
    end
end

if passed
    details = struct();
end


end