function p_value = permutation_test( dist1, dist2 )
%PERMUTATION_TEST Performs a permutation test on the distributions DIST1
%and DIST2 and returns a p-value. Set plot_on = true to display a histogram
%of the permutations along with the original value of the distributions.
%Set two_sided to = true if you want to perform a two-sided test, and false 
%if a one-sided is desired. Set nbr_shuffles to desired nbr of permutations.

plot_on = true;
two_sided = true;
nbr_shuffles = 1e+3;

list_of_means = zeros(1, nbr_shuffles);
nbr_values_group1 = length(dist1);
orig_mean = mean(dist1) - mean(dist2);
merged_values = [dist1 dist2];

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


