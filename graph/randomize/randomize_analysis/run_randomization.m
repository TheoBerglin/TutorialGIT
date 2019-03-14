function gm_list = run_randomization(A, type, randomize_function, n_randomizations)
% RUN_RANDOMIZATION This function takes an adjacency matrix A representing a
% graph of type TYPE, a randomization function RANDOMIZE_FUNCTION which we
% want to test and the number of times we want to randomize the graph
% N_RANDOMIZATIONS as input.
% Returns a struct of global measures GM_LIST

gm = calculate_global_measures(zeros(5), zeros(5), type); % For initialization of gm_list
gm_list = repmat(gm, 1, n_randomizations); % Initialization

% Lets run randomization
for i = 1:n_randomizations
    eval(sprintf('rA = %s(A);', randomize_function));
    gm = calculate_global_measures(rA, A, type);
    gm_list(i) = gm;
end

end

