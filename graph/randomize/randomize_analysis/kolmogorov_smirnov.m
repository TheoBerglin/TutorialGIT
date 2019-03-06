function [equal_dist, p_value] = kolmogorov_smirnov(d1, d2, alpha)
% KOLMOGOROV_SMIRNOV runs the Kolmogorov-Smirnov test
%
% [EQUAL_DIST, P_VALUE] = KOLMOGOROV_SMIRNOV(D1,D2,ALPHA) calculates the
% Kolmogorov-Smirnov test if data D1 and data D2 are from the same
% distribution based on the significance level ALPHA. Standard ALPHA value
% is 0.05. EQUAL_DIST = true if the data are from the same distribution.
% p_value is the p-value of the Kolmogorov-Smirnov test.

if ~exist('alpha','var')
    alpha = 0.05;
end

[h, p_value] = kstest2(d1, d2, 'Alpha', alpha);

% The null hypothesis is that the data is from the same distribution. If
% h is 1 then we reject the null hypothesis and the two sets of data are
% from different distributions. If h is 0 the data is from the same
% distribution.
if h
    equal_dist = false;
else
    equal_dist = true;
end
end

