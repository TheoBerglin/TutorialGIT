function Ar_reweighed = randomize_combo_WD_fix( A )
%RANDOMIZE_GIO_REWEIGH Summary of this function goes here
%   Detailed explanation goes here

A = remove_diagonal(A);
A_bin = sign(A);
Ar = randm_giovanni_bd_fix(A_bin);
Ar_reweighed = distribute_weights_directed(A, Ar);

end

