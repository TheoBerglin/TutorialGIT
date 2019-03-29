function nr_edges = validate_randomization( rA, A_orig )
%VALIDATE_RANDOMIZATION Checks how many edges that have not been rewired 

nr_edges = nnz(rA == 1 & A_orig == 1);

end

