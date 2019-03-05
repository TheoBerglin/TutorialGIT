function gm = calculate_global_measures(A, type)
%CALCULATE_GLOBAL_MEASURES calculates the global measures of graph A and
%returns all these in a struct extending the GM
measures = {'assortativity_in_in.m',...
    'assortativity_in_out.m',...
    'assortativity_out_in.m',...
    'assortativity_out_out.m',...
    'characteristic_pathlength.m',...
    'characteristic_pathlength_in.m',...
    'characteristic_pathlength_out.m',...
    'clustering_average.m',...
    'degree_average.m',...
    'degree_in_average.m',...
    'degree_out_average.m',...
    'density.m',...
    'diameter.m',...
    'diameter_in.m',...
    'diameter_out.m',...
    'eccentricity_average.m',...
    'eccentricity_in_average.m',...
    'eccentricity_out_average.m',...
    'global_efficiency_average.m',...
    'global_efficiency_in_average.m',...
    'global_efficiency_out_average.m',...
    'local_efficiency_average.m',...
    'radius.m',...
    'radius_in.m',...
    'radius_out.m',...
    'strength_average.m',...
    'strength_in_average.m',...
    'strength_out_average.m'};
out_var = {'ass_in_in',...
    'ass_in_out',...
    'ass_out_in',...
    'ass_out_out',...
    'cpl',...
    'cpl_in',...
    'cpl_out',...
    'clustering_av',...
    'degree_av',...
    'degree_in_av',...
    'degree_out_av',...
    'density',...
    'diameter',...
    'diameter_in',...
    'diameter_out',...
    'ecc_av',...
    'ecc_in_av',...
    'ecc_out_av',...
    'gleff_av',...
    'gleff_in_av',...
    'gleff_out_av',...
    'leff_av',...
    'radius',...
    'radius_in',...
    'radius_ou',...
    'str_av',...
    'str_in_av',...
    'str_out_av'};

gm = struct();
n_measures = size(measures,2);
% Evaluate all measures
for i = 1:n_measures
   func = replace(measures{i}, '.m', '');
   eval(sprintf('gm.%s = %s(A, type);', out_var{i}, func))
end
end

