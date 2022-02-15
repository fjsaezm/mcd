% Fingerprint Biometrics Lab


clear all
close all

%include the path with the functions to use
addpath('.\data');

%obtain fingerprint images
I1=imread(['example1_1.png']);
I2=imread(['example1_2.png']);
%subplot(121)
%imagesc(I1)
%subplot(122)
%imagesc(I2)


%Fingerprint Enhancement - FFT Magnitude
[cimg, oimg,fimg,bwimg,eimg,enhI1] =  fft_enhance_cubs(I1, -1);
[cimg, oimg,fimg,bwimg,eimg,enhI2] =  fft_enhance_cubs(I2, -1);
%figure
%subplot(121)
%imagesc(enhI1)
%subplot(122)
%imagesc(enhI2)


%Quality Maps
[newim, binI1, mask1, relI1, I1_enhaced] =  testfin(enhI1);  % testfin is from Dr. Peter Kovesi's code
[newim, binI2, mask2, relI2, I2_enhaced] =  testfin(enhI2);
%figure
%subplot(121)
%imagesc(relI1)
%subplot(122)
%imagesc(relI2)

min(relI1,[],'all');
max(relI1,[],'all');

min(relI2,[],'all');
max(relI2,[],'all');

%Binarized and Segmented Fingerprints
threshold=0.9; %quality threshold
%figure;
%subplot(121)
%imagesc(binI1+mask1+(relI1>threshold)) 
binI1(relI1<threshold)=0; 
inv_binI1 = (binI1 == 0); 
%subplot(122)
%imagesc(binI2+mask2+(relI2>threshold))
binI2(relI2<threshold)=0;
inv_binI2 = (binI2 == 0);


%Fingerprint Skeleton
thin1 =  bwmorph(inv_binI1, 'thin',Inf);
thin2 =  bwmorph(inv_binI2, 'thin',Inf);

%figure;
%subplot(121)
%imagesc(thin1)
%subplot(122)
%imagesc(thin2)


%Minutiae Extractor
window=3; 
margin=13;           
[minutiae1, minutiae_x1, minutiae_y1,my_time(7)]=extraction(thin1,window,margin);
[minutiae2, minutiae_x2, minutiae_y2,my_time(7)]=extraction(thin2,window,margin);





%Minutiae Validation
window=3; 
[valid1, valid_x1, valid_y1, my_time(8)]=validation(thin1,minutiae1,window);
[valid2, valid_x2, valid_y2, my_time(8)]=validation(thin2,minutiae2,window);

%Represent the minutiae extracted (red crosses) y validated (blue circles)
figure;
subplot(121)

thin1_comp = imcomplement(thin1)
thin2_comp = imcomplement(thin2)

imshow(thin1_comp)
hold on
plot(minutiae_y1,minutiae_x1, 'rx','MarkerSize',12,'Marker','x','LineWidth',2);
plot(valid_y1,valid_x1, 'bo','MarkerSize',12,'LineWidth',2);
hold off;

subplot(122)

imshow(thin2_comp)
hold on
plot(minutiae_y2,minutiae_x2, 'rx','MarkerSize',12,'Marker','x','LineWidth',2);
plot(valid_y2,valid_x2, 'bo','MarkerSize',12,'LineWidth',2);
hold off;



return

%Matching - Hough Transformation
score=Hough(valid_x1,valid_y1,valid_x2,valid_y2);
fprintf(['Matching Score = ',num2str(score),'\n'])



