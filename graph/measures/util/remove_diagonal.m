function B = remove_diagonal( A )
% REMOVE_DIAGONAL sets diagonal elements of matrix A to 0
%
% B = REMOVE_DIAGONAL(A) sets diagonal elements of matrix A to 0
%
% Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei, Giovanni Volpe
% Date: 2019/01/29
% http://braph.org/

B = A;
B(1:length(A)+1:numel(A)) = 0;

end