function fc = fully_connectedness( A, type )
%FULLY_CONNECTEDNESS Checks the fully connectedness of a matrix, i.e. the
%fraction of connected edges of all the edges
D = distance(A, type);
con_edges = nnz(~isinf(D));
fc = con_edges/numel(D);

end

