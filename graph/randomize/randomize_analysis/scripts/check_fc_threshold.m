clc, clear all;

n = 50;
types = {Graph.BD, Graph.BU};
densities = [0.01 0.015 0.02 0.025 0.03 0.035 0.04 0.045 0.05 0.055 0.06 ...
     0.065 0.07 0.075 0.08 0.085 0.09 0.095 0.1 0.15 0.2 0.25];
%densities = [0.0001 0.0005 0.001 0.0015 0.002 0.0025 0.003 0.004 0.005 0.007 0.01 0.015 0.02];
gen_new = true;
nbr_of_iter = 1000;
type_str = {};
fc_nnz_arr = zeros(length(types), length(densities));

for i=1:length(types)
    type = types{i};
    dir = Graph.is_directed(type);
    wei = Graph.is_weighted(type);
    if wei
        type_bin = 'wei';
    else
        type_bin = 'bin';
    end
    if dir
        type_dir = 'dir';
    else
        type_dir = 'undir';
    end

%     fc_arr = zeros(1, length(densities));


    for di = 1:length(densities)
        dens = densities(di);
        fc = zeros(1, nbr_of_iter);
        for iter = 1:nbr_of_iter
            if gen_new
                A = create_matrix(dens*100, n, dir, wei);
            else    
                load_file = sprintf('dens_%s_nodes_%d_%s_%s.txt', num2str(dens, '%.3f'), n, type_bin, type_dir);
                if exist(load_file, 'file')
                    A = load(load_file);
                else
                    fprintf('Did not load matrix dens: %.3f %s %s\n', dens, type_bin, type_dir)
            dens = densities(di);

                    A = create_matrix(dens*100, n, dir, wei);
                end
            end
            fc(iter) = fully_connectedness(A, type);
%             fc(iter) = fiedler_fully_connected(A, type);
        end
%         fc_arr(di) = mean(fc);
        fc_nnz_arr(i, di) = nnz(fc == 1);
%         fc_nnz_arr(i, di) = nnz(fc);
    end

    if type == Graph.BD
        type_str{i} = 'Graph.BD';
    elseif type == Graph.BU
        type_str{i} = 'Graph.BU';
    elseif type == Graph.WD
        type_str{i} = 'Graph.WD';
    else
        type_str{i} = 'Graph.WU';
    end
end

% figure()
% plot(densities, fc_arr)
% xlabel('Density')
% ylabel('Fully connectedness')
% str = sprintf('%s, size: %d, #generations: %d', type_str, n, nbr_of_iter);
% title(str)

figure()
for i = 1:length(types)
    plot(densities, fc_nnz_arr(i,:)./nbr_of_iter)
    hold on;
end
legend(type_str{1}, type_str{2})
xlabel('Density')
ylabel('Fraction of fully connected matrices')
str = sprintf('Size: %dx%d, nbr of matrix generations: %d', n,n, nbr_of_iter);
title(str)
