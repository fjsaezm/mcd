
addpath(cd)
addpath('DetPlots')
warning('off','all');
max = 20;
coeff = (1:20);
X = zeros(max);
n_train = 6;
n_test = 4;


for i=1:max
    X(i) = eer(n_train,n_test,i);
end

[mr,mir] = min(X);


figure;
hold on;
plot(coeff,X);
stem(mir(1),mr(1),'filled','MarkerFaceColor','red', 'LineStyle','none');
title('Evolution of EER with Coefficients');
xlabel('Coeffs');
ylabel('EER [%]');
hold off;