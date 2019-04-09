function sampled_pvalues = sample_pvalues( dist1, dist2, nbr_of_samples, sample_size, w_replacement )
% SAMPLE_PVALUES 


%% Check for input
if ~exist('nbr_of_samples', 'var')
    nbr_of_samples = 100;   
end
if ~exist('sample_size', 'var')
    sample_size = 100;   
end
if ~exist('w_replacement', 'var')
    w_replacement = true;
end

% If sampling without replacements, make sure enough elements
if ~w_replacement
    if length(dist1) < nbr_of_samples*sample_size || length(dist2) < nbr_of_samples*sample_size
        error('Number of samples * sample size must be smaller or equal to the amount of elements in the distributions');
    end
    dist1 = dist1(randperm(length(dist1)));  % shuffle data
    dist2 = dist2(randperm(length(dist2)));  % shuffle data
end

%% Sample and run permutation test
sampled_pvalues = zeros(1, nbr_of_samples);
for i = 1:nbr_of_samples
    if w_replacement
        dist1_sample = dist1(randperm(length(dist1), sample_size));
        dist2_sample = dist2(randperm(length(dist2), sample_size));
    else
        start_idx = (i-1)*sample_size+1;
        end_idx = sample_size*i;
        dist1_sample = dist1(start_idx:end_idx);
        dist2_sample = dist2(start_idx:end_idx);
    end
    sampled_pvalues(i) = permutation_test(dist1_sample, dist2_sample);
end

end

