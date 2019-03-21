function Ar_reweighed = randomize_combo_WU( A )
%RANDOMIZE_GIO_REWEIGH Summary of this function goes here
%   Detailed explanation goes here

A = remove_diagonal(A);
A_bin = sign(A);
Ar = randm_giovanni_bu(A_bin);
Ar_reweighed = distribute_weights_undirected(A, Ar);

end

