function [valid, n_eq_dist, n_meas] = run_validation(gm_list_1, gm_list_2, alpha)
% RUN_VALIDATION Runs a comparison with two structs of global measures
% GM_LIST_1 and GM_LIST_2 and returns a struct of validation information.
% The validation tests is a Kolmogorov-Smirnov test with confidence level
% ALPHA. ALPHA is set to 0.05 by default.

fields = fieldnames(gm_list_1);
valid = struct();
n_eq_dist = 0; % Number of equal distributions
n_meas = length(fields); % Number of measures to test
for i = 1:n_meas
    field = fields{i};
    % Data to compare
    d1 = extractfield(gm_list_1, field);
    d2 = extractfield(gm_list_2, field);
    % Run Kolmogorov-Smirnov test
    [equal_dist, p_value] = kolmogorov_smirnov(d1, d2, alpha);
    valid.(field) = struct('equal', equal_dist, 'pvalue', p_value);  
    n_eq_dist = n_eq_dist + equal_dist;
end

end

