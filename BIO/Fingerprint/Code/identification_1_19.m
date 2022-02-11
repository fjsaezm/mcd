% Fingerprint Biometrics Lab

% Fill in the gaps in the code

clear all
close all
clc
addpath(genpath('.\data'));

%Load the unkonwn image
I_input=imread(['.\ddbb\Unknown.png']);

%Based on main.m create a function extract_minutiae.m that outputs the
%X and Y positions of the minutiae already validated. Find the optimal 
%parameters for this task
[valid_x_input,valid_y_input]=extract_minutiae(I_input);

%For the 19 fingerprints 
Scores = zeros(1,19);
for i=1:19
    
    %Process the database to read the images
    if i<10
        nameFingerprint = ['.\ddbb\H000' num2str(i) '.png'];
    else
        nameFingerprint = ['.\ddbb\H00' num2str(i) '.png'];
    end
    
    %Load one image. 
    
    %YOUR CODE HERE
    
    %extract the minutiae. You can call function "extract_minutiae"
   
    %YOUR CODE HERE
   
   %get the matching score making use of the Hough function. Save in the right 
   %position of the Scores variable
   
   %YOUR CODE HERE       
   
end

%extract the image with highest score
index_maxScores=find(Scores==max(Scores));

fprintf(['The unkown fingerprint corresponds to the same identity to image H',num2str(index_maxScores), '\n'])
