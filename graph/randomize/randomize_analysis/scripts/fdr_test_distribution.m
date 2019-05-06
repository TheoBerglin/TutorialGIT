clear all, clc, close all;
n_comp = 500;

p_equal = zeros(1,n_comp);
p_unequal = zeros(1,n_comp);

for i = 1:n_comp
    y = normrnd(0, 1, [1, 500]);
    y2 = normrnd(0, 1, [1, 500]);
    y3 = normrnd(0.2, 1, [1, 500]);
    p_equal(i) = permutation_test(y, y2, false, true, 500);
    p_unequal(i) = permutation_test(y, y3, false, true, 500);
end
%% Sort the p values
p_equal = sort(p_equal);
p_unequal = sort(p_unequal);
%% Plot equal
x = 1:1:length(p_equal);
figure();
plot(x, sort(p_equal));
hold on;
plot(x, 0.05*x/length(p_equal));
fails = sum(p_equal<=0.05*x/length(p_equal));
title(['N(0,1) vs N(0,1), FDR: ' num2str(round(fails/length(p_equal),2))])

ylabel('P-value')
xlabel('Number of samples')

%% Plot unequal
x = 1:1:length(p_unequal);
figure();
plot(x, sort(p_unequal));
hold on;
plot(x, 0.05*x/length(p_unequal));
fails = sum(p_unequal<=0.05*x/length(p_unequal));
title(['N(0.2,1) vs N(0,1), FDR: ' num2str(round(fails/length(p_unequal),2))])

ylabel('P-value')
xlabel('Number of samples')
