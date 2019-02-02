function B = replace_diagonal( A, value )
% REPLACE_DIAGONAL sets diagonal elements of matrix A to value
%
% B = REPLACE_DIAGONAL(A, VALUE) sets diagonal elements of matrix A to
% VALUE
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/29
% http://braph.org/

B = A;
B(1:length(A)+1:numel(A)) = value;

end