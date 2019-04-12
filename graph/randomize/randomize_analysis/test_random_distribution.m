%% Settings
clear all
A_org = [0 0 1 0;1 0 0 1;1 0 0 1;0 1 0 0];
%B_org = [0 0 1 0;1 0 1 1;0 1 0 1;1 0 0 0];
%C_org = [0 1 0 0;1 0 1 1;1 0 0 1;0 0 1 0];
%D_org = [0 0 0 1;1 0 1 1;1 1 0 0;0 0 1 0];
n_runs = 10000;
data(1) = struct('A', A_org, 'count', 0);
% data(2) = struct('A', B_org, 'count', 0);
% data(3) = struct('A', C_org, 'count', 0);
% data(4) = struct('A', D_org, 'count', 0);
full_data(1) = struct('org', A_org, 'distribution', data);
% full_data(2) = struct('org', B_org, 'distribution', data);
% full_data(3) = struct('org', C_org, 'distribution', data);
% full_data(4) = struct('org', D_org, 'distribution', data);
for org_i = 1:1  
    method = 'randmio_dir_signed_edit';
    
    for i=1:n_runs
        
        eval(sprintf('rA = %s(full_data(org_i).org);', method));
        n_matrices = length(full_data(org_i).distribution);
        found = false;
        for ci = 1:n_matrices
            if all(all(full_data(org_i).distribution(ci).A == rA))
                full_data(org_i).distribution(ci).count = full_data(org_i).distribution(ci).count + 1;
                found = true;
                break
            end
        end
        if ~found
            full_data(org_i).distribution(n_matrices+1) = struct('A', rA, 'count', 1);
        end
        
    end
end
