function II=segment(I)
% function to perform K-means segmentation
%
% inputs
% I: input image
%
% outputs
% II: binary segmented image

K=3; % K is set to 2
[ROW,COL,CHN]=size(I);
II=zeros(ROW,COL);
% initial means are set to means of pixels whose red components are higher
% and lower than 150
II(find(I(:,:,1)>3*pi/4))=1;
II=bwfill(II,'holes');
points=ROW*COL;
P=zeros(points,CHN);
for c=1:CHN
    C=I(:,:,c);
    means(1,c)=mean(C(find(II)));
    means(2,c)=mean(C(find(not(II))));
    P(:,c)=C(:);
end
iter=0;
E=ones(1,K);
while sum(E)>0
    for k=1:K
        if iter>0
            temp=mean(P(find(segments==k),:));
            E(k)=sum(abs(temp-means(k,:)));
            means(k,:)=temp;
        end
        D(:,k)=sum((P-repmat(means(k,:),points,1)).^2,2);
    end
    % assuming foreground object to be smaller than background labels are
    % given as 1 and 2 respectively
    [m,segments]=min(D,[],2);
    iter=iter+1;
end
% segments(find(segments==2))=0; % background is set back to zero
II(:)=segments;
