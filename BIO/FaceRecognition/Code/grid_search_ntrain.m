close all
clear all
clc

addpath(cd);
addpath('DetPlots');
warning('off','all');
min_ntrain = 1;
max_ntrain = 9;
iters = (1:9);
n_iters = max_ntrain - min_ntrain;
X = zeros(n_iters);
optimal_coeff = 5;

plot_curve = false;

for i=min_ntrain:max_ntrain
    X(i-min_ntrain+1) = eer(i,max_ntrain - i,optimal_coeff,plot_curve);
end

[mr,mir] = min(X);


figure;
hold on;
plot(iters,X(1:9));
stem(mir(1),mr(1),'filled','MarkerFaceColor','red', 'LineStyle','none');
title('Evolution of EER with n\_train');
xlabel('n_train');
ylabel('EER [%]');
hold off;