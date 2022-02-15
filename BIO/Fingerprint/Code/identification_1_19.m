% Fingerprint Biometrics Lab

clear all
close all
clc
addpath(genpath('.\data'));

opt_minut_window = 3;
opt_minut_margin = 8;
opt_val_window = 3;

%Load the unkonwn image
I_input=imread(['.\ddbb\Unknown.png']);

%Based on main.m create a function extract_minutiae.m that outputs the
%X and Y positions of the minutiae already validated. Find the optimal 
%parameters for this task
[valid_x_input,valid_y_input]=extract_minutiae(I_input,opt_minut_window,opt_minut_margin, opt_val_window);

%For the 19 fingerprints 
Scores = zeros(1,19);
for i=1:19
    fprintf('%g \n', i);
    %Process the database to read the images
    if i<10
        nameFingerprint = ['.\ddbb\H000' num2str(i) '.png'];
    else
        nameFingerprint = ['.\ddbb\H00' num2str(i) '.png'];
    end
    
    %Load one image.
    I = imread([nameFingerprint]);
    
    %extract the minutiae
    [valid_x, valid_y] = extract_minutiae(I,opt_minut_window,opt_minut_margin, opt_val_window);
   

    %get the matching score making use of the Hough function
    Scores(i) = Hough(valid_x,valid_y,valid_x_input,valid_y_input);
   
end

%extract the image with highest score
index_maxScores=find(Scores==max(Scores));

fprintf('%g \n', Scores);
fprintf(['The unkown fingerprint corresponds to the same identity to image H',num2str(index_maxScores), '\n'])

writematrix(Scores,'../Results/3-8-3.csv')
