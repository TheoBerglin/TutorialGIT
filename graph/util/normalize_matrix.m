function B = normalize_matrix( A )
% NORMALIZE_MATRIX normalizes the matrix so that all values are within [-1,1]
%
% B = NORMALIZE_MATRIX(A) normalizes the elements of A so that all values
%   are within [-1, 1]
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/02/05
% http://braph.org/

maxA = max(max(abs(A)));
B = A./maxA;

end