function [valid_x,valid_y]=extract_minutiae(I,minutiae_window,minutiae_margin,val_window)

    % Enhance
    [nil, nil,nil,nil,relI,enhI] =  fft_enhance_cubs(I, -1);
    % Quality map
    [nil, binI, nil, nil, nil] =  testfin(enhI);  
    % Binarize and Segment Fingerprint
    threshold=0.9; 
    binI(relI<threshold)=0; 
    inv_binI = (binI == 0);
    %Fingerprint Skeleton
    thin =  bwmorph(inv_binI, 'thin',Inf);

    %Minutiae Extractor          
    [minutiae, minutiae_x, minutiae_y,nil]=extraction(thin,minutiae_window,minutiae_margin);

    %Minutiae Validation
    [nil, valid_x, valid_y, nil]=validation(thin,minutiae,val_window);

end