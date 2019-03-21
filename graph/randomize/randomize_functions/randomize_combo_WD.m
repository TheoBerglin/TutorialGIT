function Ar_reweighed = randomize_combo_WD( A )
%RANDOMIZE_GIO_REWEIGH Summary of this function goes here
%   Detailed explanation goes here

A = remove_diagonal(A);
A_bin = A>0;
Ar = randm_giovanni_bd(A_bin);
Ar_reweighed = distribute_weights_directed(A, Ar);

end

