function A = create_matrix(density, size, dir, wei)
edges = size*size;
indizes = randperm(edges, round(edges*density));
A = zeros(size, size);
A(indizes) = 1;

%% Binary/weight settings
if wei
    W = rand(nodes);
    A = A.*W;
end

%% Directed/undirected settings
if ~dir
    %Symmetrize if undirected
    A = triu(A);
    A = A+A.';
end
A = replace_diagonal(A, 1);

end