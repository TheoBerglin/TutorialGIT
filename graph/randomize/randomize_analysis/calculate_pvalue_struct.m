function p_value_struct = calculate_pvalue_struct(gm_struct1, gm_struct2)
%CALCULATE_PVALUE_STRUCT Summary of this function goes here
%   Detailed explanation goes here
fields = fieldnames(gm_struct1);
p_value_struct = struct();
for i = 1:length(fields)
    field = fields{i};
    dist1 = extractfield(gm_struct1, field);
    dist2 = extractfield(gm_struct2, field);
    p_value_struct.(field) =   permutation_test(dist1, dist2);  
end
end

