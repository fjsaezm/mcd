close all
clear all
clc

%load de signature parameters
mat=load('BiosecurIDparameters.mat');
BiosecurIDparameters=mat.BiosecurIDparameters;

%YOUR CODE       
figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,1), 'Normalization', 'probability');
title("Normalized histogram of Ttotal")
hold off;

            
figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,2),'Normalization', 'probability');
title("Normalized histogram of Npenups")
hold off;
            
figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,3),'Normalization', 'probability');
title("Normalized histogram of Tpendown")
hold off;
            
figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,4),'Normalization', 'probability');
title("Normalized histogram of Ppendown")
hold off;
            