clear all, close all;
file_name = 'bias_braph_randomize_braph_BU_bias_fix.mat';
nodes = 50;
data = load(file_name);
data = data.data;
for i = 1:length(data)
    if data(i).nodes == nodes
        data = data(i).node_data;
        mw = zeros(1, length(data));
        dens = zeros(1, length(data));
        rw = zeros(1, length(data));
        rw_nnz = zeros(1, length(data));
        for j=1:length(data)
            mw(j) = mean(data(j).miswires);
            rw(j) = mean(data(j).random_wires);
            rw_nnz(j) = nnz(data(j).random_wires);
            dens(j) = data(j).density;
        end
    end
end

figure()
plot(dens, rw_nnz);
xlabel('Density')
ylabel('Number of events of odd cycles')
title('500 runs')
figure()
plot(dens, rw);
xlabel('Density')
ylabel('Mean number of times we correct miswires')
title('500 runs')
figure()
plot(dens, mw);
xlabel('Density')
ylabel('Mean number of miswires after randomization')
title('500 runs')