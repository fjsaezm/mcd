
close all
clear all
clearvars
warning('off','all');


%Divide the number of images per user for Train and Test:
Train=6;
Test=4;

% we add paths to facilitate the code
addpath(cd)
addpath('DetPlots')
cd FaceDatabaseATT
dirListA=dir;
dirList=dirListA(4:43);

% Size of image: 92 x 112
length = 92;
width = 112;
size = length*width;

%Initialize the Feature and Label Matrix for both train and test
MatrixTrainFeats=zeros(Train*40,size); 
MatrixTestFeats=zeros(Test*40,size); 
MatrixTrainLabels=zeros(Train*40,1); %each row contains the ID of the user
MatrixTestLabels=zeros(Test*40,1); %each row contains the ID of the user


for i=1:numel(dirList) %Loop for each user
   
    cd(dirList(i).name);
    images=dir('*.pgm');
    
    for j=1:10
       im=imread(images(j).name);
       im=double(im);
        
       % Flatten image and add it to big matrix
       im_flat = reshape(im.',1,[]);

       %%%  Training Dataset
       if j <= Train
           
           MatrixTrainFeats((i-1)*Train + j, : ) = im_flat;
           MatrixTrainLabels((i-1)*Train + j, 1) = i;

       %%% Test dataset
       else

           MatrixTestFeats((i-1)*Test + (j - Train), : ) = im_flat;
           MatrixTestLabels((i-1)*Test + (j - Train), 1) = i;

       end
    
    end

    
    cd ..
    
end

cd ..


% PCA STAGE

% PCA on Training matrix
[PCA_coeffs,MatrixTrainPCA,latent,none,explained,mu] = pca(MatrixTrainFeats);
%MatrixTestPCA = (MatrixTestFeats - mu)*PCA_coeffs;


test_all_comps = false;

if test_all_comps
    % Project Test Set
    MatrixTestPCA = (MatrixTestFeats - mu)*PCA_coeffs;

    % Select ncomps components
    MatrixTrainSelectedPCA = MatrixTrainPCA;
    tic
    EER = compute_eer_svm(MatrixTrainPCA,MatrixTestPCA, ...
                                MatrixTrainLabels,MatrixTestLabels,...
                                'rbf',...
                                true)

    toc
end



min_comps = 3;
max_comps = numel(explained);
EER_comps = zeros(max_comps-min_comps + 1);


tic
for ncomps=min_comps:max_comps

    % Project Test Set
    MatrixTestPCA = (MatrixTestFeats - mu)*PCA_coeffs(:, 1:ncomps);

    % Select ncomps components
    MatrixTrainSelectedPCA = MatrixTrainPCA(:,1:ncomps);

    EER = compute_eer_svm(MatrixTrainSelectedPCA,MatrixTestPCA, ...
                                MatrixTrainLabels,MatrixTestLabels,...
                                'polynomial',...
                                false);
    
    EER_comps(ncomps - min_comps + 1) = EER;
   

end
toc

[m,min_pos] = min(EER_comps(1:max_comps - min_comps));
% Adjust min pos to starting position
min_pos = min_pos + min_comps - 1;
fprintf('Min EER is obtained with %d components\n',min_pos(1) + min_comps - 1)
fprintf('Minimum EER is  %d \n',m)

plot_optimal_pca_det = true;

if plot_optimal_pca_det
    optim_comps = min_pos(1);
    MatrixTestPCA = (MatrixTestFeats - mu)*PCA_coeffs(:, 1:optim_comps);
    MatrixTrainSelectedPCA = MatrixTrainPCA(:,1:optim_comps);

    EER = compute_eer_svm(MatrixTrainSelectedPCA,MatrixTestPCA, ...
                                MatrixTrainLabels,MatrixTestLabels,...
                                'linear',...
                                true);

end

figure;
hold on;
plot((min_comps:max_comps),EER_comps(1:max_comps-min_comps + 1));
stem(min_pos(1),m(1),'filled','MarkerFaceColor','red', 'LineStyle','none');
title('EER per number of components selected by PCA');
xlabel('Number of Components');
ylabel('EER');
hold off;







