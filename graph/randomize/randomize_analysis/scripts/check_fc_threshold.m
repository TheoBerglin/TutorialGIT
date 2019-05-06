clc, clear all;

sizes = [50 60 70 80 90 100 120 140 150];
types = {Graph.BU};
densities = [0.005 0.0075 0.01 0.015 0.02 0.025 0.03 0.035 0.04 0.045 0.05 0.055 0.06 ...
    0.065 0.07 0.075 0.08 0.085 0.09 0.095 0.1 0.15 0.2];
gen_new = true;
nbr_of_iter = 1000;
type_str = {};
fc_nnz_arr = zeros(length(types), length(densities));
cut_off_dens = zeros(1, length(sizes));

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
    
    for ni = 1:length(sizes)
        n = sizes(ni);
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
            end
            if nnz(fc == 1)/nbr_of_iter > 0.01  % 1% fcness
                cut_off_dens(ni) = dens;
                break;
            end
        end
     end
%     if type == Graph.BD
%         type_str{i} = 'Graph.BD';
%     elseif type == Graph.BU
%         type_str{i} = 'Graph.BU';
%     elseif type == Graph.WD
%         type_str{i} = 'Graph.WD';
%     else
%         type_str{i} = 'Graph.WU';
%     end
end

save_struc = struct('cutoff', [sizes', cut_off_dens']);
save('cutoff.mat', 'save_struc')

% figure()
% plot(densities, fc_arr)
% xlabel('Density')
% ylabel('Fully connectedness')
% str = sprintf('%s, size: %d, #generations: %d', type_str, n, nbr_of_iter);
% title(str)
% 
% figure()
% for i = 1:length(types)
%     plot(densities, fc_nnz_arr(i,:)./nbr_of_iter)
%     hold on;
% end
% legend(type_str{1}, type_str{2})
% xlabel('Density')
% ylabel('Fraction of fully connected matrices')
% str = sprintf('Size: %dx%d, nbr of matrix generations: %d', n,n, nbr_of_iter);
% title(str)
