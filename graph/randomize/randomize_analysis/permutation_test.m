function p_value = permutation_test( dist1, dist2, plot_on, two_sided, shuffles)
% PERMUTATION_TEST Performs a permutation test on the distributions DIST1
% and DIST2 and returns a p-value. Set plot_on = true (default=false) to display a histogram
% of the permutations along with the original value of the distributions.
% Set two_sided to = true (default=true) if you want to perform a two-sided test, and false 
% if a one-sided is desired. Set nbr_shuffles (default=1000) to desired nbr of permutations.

%% Variable check
if ~exist('plot_on', 'var')
    plot_on = false;   
end
if ~exist('two_sided', 'var')
    two_sided = true;
end
if ~exist('shuffles', 'var')
    nbr_shuffles = 1e+3;
end

%% Spring cleaning
% Remove nans
dist1 = dist1(~isnan(dist1));
dist2 = dist2(~isnan(dist2));
% Remove inf
dist1 = dist1(~isinf(dist1));
dist2 = dist2(~isinf(dist2));
if isempty(dist1) || isempty(dist2)
   disp('All values removed')
   p_value = -999;
   return
end

list_of_means = zeros(1, nbr_shuffles);
nbr_values_group1 = length(dist1);
orig_mean = mean(dist1) - mean(dist2);
if size(dist1, 2) > size(dist1, 1)
    merged_values = [dist1 dist2];
else
    merged_values = [dist1.' dist2.'];
end

for i=1:nbr_shuffles
    shuffled_indices = randperm(length(merged_values));
    group1_new = merged_values(shuffled_indices(1:nbr_values_group1));
    group2_new = merged_values(shuffled_indices(nbr_values_group1+1:end));
    list_of_means(i) = mean(group1_new) - mean(group2_new);
end

if two_sided
    elem_in_tail = sum(abs(list_of_means) >= abs(orig_mean));
else
    overall_mean = mean(list_of_means);
    if orig_mean >= overall_mean  % right_tail
        elem_in_tail = sum(list_of_means >= orig_mean);
    else  % left tail
        elem_in_tail = sum(list_of_means <= orig_mean);
    end
end

p_value = elem_in_tail/nbr_shuffles;

if plot_on
    figure();
    histogram(list_of_means);
    hold on;
    plot(linspace(orig_mean, orig_mean, 100), linspace(0, nbr_shuffles/4,100))
end

end


