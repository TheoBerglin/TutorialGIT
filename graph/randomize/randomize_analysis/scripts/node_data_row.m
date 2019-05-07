function row = node_data_row(data,dens, type)
dir = Graph.is_directed(type);
wei = Graph.is_weighted(type);
if isempty(fieldnames(data))
    row = 1;
    return
end

if length(data) == 1 && isequal(data(1).desc, 'TEMP')
    row = 1;
    return
end

dens_arr = extractfield(data, 'density');
dir_arr = extractfield(data, 'directed');
dir_arr = cell2mat(dir_arr);
wei_arr = extractfield(data, 'weighted');
wei_arr = cell2mat(wei_arr);
dens_i = find(abs(dens_arr - dens) < 0.0001);
dir_i = find(dir_arr == dir);
wei_i = find(wei_arr == wei);

row =intersect(intersect(dens_i, dir_i),wei_i);
if isempty(row)
    row = length(data)+1;
end


end

