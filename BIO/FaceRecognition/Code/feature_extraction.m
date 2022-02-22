function [param] = feature_extraction (image,coeff)
%% Feature extraction based on first coefficient of the DCT tranform
image_dct=dct2(image);

%plot the DCT image
figure;imshow(image_dct);

%Get the feature vector of the corresponding coefficients 
for i=1:coeff,
    %we save all features in a row format
    param(coeff*(i-1)+1:coeff*i)=image_dct(i,1:coeff);
end

param=param(2:end); %the first coefficient is the brightness offset
