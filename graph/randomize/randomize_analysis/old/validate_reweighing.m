densities = {'0.050' '0.100' '0.150' '0.200' '0.250' '0.300' '0.350' '0.400'...
    '0.450' '0.500' '0.550' '0.600' '0.650' '0.700'};
nbr_of_randomizations = 10;
counter = 0;
for i = 1:length(densities)
    disp(densities{i})
    mat_name = sprintf('dens_%s_nodes_100_bin_dir.txt', densities{i});
    A = load(mat_name);
    for i=1:nbr_of_randomizations
        unaff = reweighing_bct_D(A);
        counter = counter + unaff;
    end
end
fprintf('Unaffected matrices by reweighing: %d\n', counter)
fprintf('Total nbr of tested matrices: %\n', (nbr_of_randomizations*length(densities)))
