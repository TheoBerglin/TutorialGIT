function r = pearson_correlation(j, k, M)
% PEARSON_CORRELATION calculates the Pearson correlation between data j and k
%
% R = PEARSON_CORRELATION(J, K, M) calculates the Pearson correlation between the
%   degree/strength J and K of either end of an edge. M is the number of edges.
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/12
% http://braph.org/

num = sum(j.*k)/M - (sum(0.5*(j+k))/M)^2;
denom = sum(0.5*(j.^2+k.^2))/M - (sum(0.5*(j+k))/M)^2;

r = num/denom; % Correlation

end