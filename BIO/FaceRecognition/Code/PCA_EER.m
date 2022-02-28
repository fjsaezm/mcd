
close all
clear all
clc
warning('off','all');
restoredefaultpath


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



plot_explained_var = false;

% Useful variables
min_comps = 1;
max_comps = numel(explained);

  
if plot_explained_var
    
    % Accumulated variance
    cumulative_variance = cumsum(explained);
   
    figure;
    hold on;
    plot((min_comps:max_comps),explained,'LineWidth',2);
    title('Variance explained by each component');
    xlabel('Component');
    ylabel('Explained Variance');
    xlim([-1 240]);
    ylim([-0.5 20]);
    hold off;
    
    figure;
    hold on;
    plot((min_comps:max_comps),cumulative_variance,'LineWidth',2, 'Color', '#ff6347');
    title('Accumulated variance');
    xlabel('Component');
    ylabel('Accumulation');
    hold off;
end

EER_comps = zeros(max_comps);

for ncomps=1:max_comps


    % Project Test Set
    MatrixTestPCA = (MatrixTestFeats - mu)*PCA_coeffs(:, 1:ncomps);

    % Select ncomps components
    MatrixTrainSelectedPCA = MatrixTrainPCA(:,1:ncomps);


    EER = compute_eer_distance(MatrixTrainSelectedPCA,MatrixTestPCA, ...
                                MatrixTestLabels,MatrixTrainLabels,...
                                Train,Test);
    
    EER_comps(ncomps) = EER;
   

end

[m,min_pos] = min(EER_comps(1:max_comps));
fprintf('Min EER is obtained with %d components\n',min_pos(1))
fprintf('Minimum EER is  %d \n',m)

figure;
hold on;
plot((min_comps:max_comps),EER_comps(1:max_comps));
stem(min_pos(1),m(1),'filled','MarkerFaceColor','red', 'LineStyle','none');
title('EER per number of components selected by PCA');
xlabel('Number of Components');
ylabel('EER');
hold off;
