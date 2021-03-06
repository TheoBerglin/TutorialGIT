%Main file for all tests

clc,clear all, close all;
%tests = dir('measures/**/_tests/test*.m');
tests = subdir(fullfile('measures', 'test_*'));
executers = dir('measures/_tests/execute*.m');
n_tests = size(tests, 1);
n_executes = size(executers,1);

for ex = 1:n_executes
    n_passed = 0;
    n_failed = 0;
    disp('--------------------------------------')
    clearvars failed_tests 
    executer_name = executers(ex).name;
    tmp = strsplit(executer_name, '.');
    executer_name = tmp{1};
    fprintf('Running for executer: %s\n', executer_name)
    for i = 1:n_tests
        file_name = tests(i).name;
        tmp = strsplit(file_name,filesep);
        tmp = strsplit(tmp{end}, '.');
        test_name = tmp{1};
        tic
        eval(['[passed, details] =' executer_name '(test_name);'])
        if passed
            fprintf('%s: PASSED (Time: %.3f s) \n', test_name, toc)
            n_passed = n_passed +1;
        else
            n_failed = n_failed + 1;
            failed_tests(n_failed) = struct('test', test_name, 'details', details);
            fprintf('%s: FAILED (Time: %.3f s) \n', test_name, toc)
        end
    end
    
    % Print failed tests details
    disp('-----------------------------------------')
    disp('-----------------Details-----------------')
    if n_failed>0
        for t = 1:size(failed_tests,2)
            disp('-----------------------------------------')
            fprintf('Failed test: %s \n',failed_tests(t).test)
            details = failed_tests(t).details;
            for d = 1:size(details, 2)
                if details(d).passed
                    temp_str = 'PASSED';
                else
                    temp_str = 'FAILED';
                end
                fprintf('%s: %s\n', details(d).name, temp_str)
            end
        end
    end
    
    % Print summary
    disp('-----------------------------------------')
    disp('-----------------Summary-----------------')
    fprintf('Executer name: %s\n', executer_name);
    fprintf('Tests passed: %d\n',n_passed)
    fprintf('Tests failed: %d\n', n_failed)
    fprintf('Success ratio: %.2f%%\n', 100*n_passed/n_tests)
end