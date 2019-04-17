function fc = fiedler_fully_connected(A)
%FIEDLER_FULLY_CONNECTED Summary of this function goes here
%   Detailed explanation goes here
try
    [~,D] = eigs(A,2,'smallestreal');
catch
    try
        [~,D] = eigs(A,size(A,1)/2,'smallestreal');
    catch
        [~,D] = eigs(A,size(A,1),'smallestreal');
    end
end
if real(D(2,2)) > 0
    fc = true;
else
    fc = false;
end
end

