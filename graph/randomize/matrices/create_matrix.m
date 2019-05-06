function A = create_matrix(density, nodes, dir, wei)
s = nodes*nodes;
possible_connections = nodes*(nodes-1);
dens = density/100;
threshold = 0.3;
A = sparse(nodes, nodes);

if dir
    % generate edges as long as desired density is not met
    while numel(find(A)) ~= round(possible_connections*dens)
        new_edges = round(possible_connections*dens) - numel(find(A));
        indices = randperm(s, new_edges);
        A(indices) = 1;
        A = remove_diagonal(A);
    end
else % undirected
    % generate edges as long as (half of the) desired density is not met
    while numel(find(A)) ~= round(possible_connections*dens/2)
        new_edges = round(possible_connections*dens/2) - numel(find(A));
        indices = randperm(s, new_edges);
        if ~isempty(indices)
            [row, col] = ind2sub(size(A), indices);
            indices_to_keep = col>row;  % fill upper triangle
            A(indices(indices_to_keep)) = 1;
            A = remove_diagonal(A);
        end
    end
end


%% Binary/weight settings
if wei
    W = threshold + (1-threshold).*rand(nodes);
    A = A.*W;
end

%% Directed/undirected settings
if ~dir
    %Symmetrize if undirected
    A = A+A.';
end

end