function row = node_data_row(data,dens, type)
dir = Graph.is_directed(type);
wei = Graph.is_weighted(type);
if isempty(fieldnames(data))
    row = 1;
    return
end

dens_arr = extractfield(data, 'density');
dir_arr = extractfield(data, 'directed');
wei_arr = extractfield(data, 'weighted');

dens_i = find(dens_arr == dens);
dir_i = find(dir_arr == dir);
wei_i = find(wei_arr == wei);

row =intersect(intersect(dens_i, dir_i),wei_i);
if isempty(row)
    row = length(data)+1;
end


end

