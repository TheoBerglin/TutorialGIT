function Ar_reweighed = randomize_combo_WU_fix( A )
%RANDOMIZE_GIO_REWEIGH Summary of this function goes here
%   Detailed explanation goes here

A = remove_diagonal(A);
A_bin = sign(A);
Ar = randomize_braph_BU(A_bin);
Ar_reweighed = distribute_weights_undirected(A, Ar);

end

