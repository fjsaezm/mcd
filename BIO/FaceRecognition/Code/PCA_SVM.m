
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


% Useful variables
min_comps = 1;
max_comps = numel(explained);

SVMModels = cell(40,1);
classes = unique(MatrixTrainLabels);

% Train a classifier per user
% (One vs all)
for i = 1:numel(classes)
    idx = MatrixTrainLabels == i;
    SVMModels{i} = fitcsvm(MatrixTrainFeats)

end

