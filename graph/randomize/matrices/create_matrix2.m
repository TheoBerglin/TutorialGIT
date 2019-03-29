function rA = create_matrix2( A )
%CREATE_MATRIX2 Summary of this function goes here
%   Detailed explanation goes here

dens = density(A);
s = size(A, 1);
if isequal(A, A.')
    dir = false;
else
    dir = true;
end

if all(all(A == 0 | A == 1))
    wei = false;
else
    wei = true;
end

rA = create_matrix(dens, s, dir, wei);


end

