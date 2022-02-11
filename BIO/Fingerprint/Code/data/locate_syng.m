% function [] = locate_syng(img,orientation_matrix,delta_location,reliability)
load Ideltas_mask.mat Ideltas


orientation_matrix=orientim;
delta_location=delta_matrix{iusu};

enhimg2=enhimg(1:2:end,1:2:end);
Iori=zeros(size(enhimg2));
offset=10;
for ibx=offset+1:5:size(enhimg2,1)-offset-1
    for iby=offset+1:5:size(enhimg2,2)-offset-1
        block=enhimg2(ibx-offset:ibx+offset,iby-offset:iby+offset);
        
        BW = imdilate(edge(block,'canny'),ones(3,3)); %imshow(BW)
        ori=regionprops(BW, 'Orientation');
        
        v_ori=[];
        for ixx=1:length(ori)
            v_ori(end+1)=ori(ixx).Orientation;
        end
       Iori(ibx,iby)=mean(v_ori)*2*pi/360;
        
    end
end



















load Ideltas_mask.mat Ideltas
blksze=2;
orients=[0:pi/8:pi];
orient_image=zeros(size(orientation_matrix));
for ibx=1:size(orientation_matrix,1)
    for iby=1:size(orientation_matrix,2)
        [inda,indb]=min(abs(orients-orientation_matrix(ibx,iby)));
        if indb==9
            indb=1;
        end
        orient_image(ibx,iby)=orients(indb(1));
    end
end
% plotridgeorient( orient_image,20, double(adapthisteq(img)), 1)

MainOrientation=[];
blksze=7;
offset=floor(blksze/2);
ini=blksze;
conta=1;
centrx=ini;
for ibx=5:round(size(orient_image,1)/blksze)-offset
    centry=ini;
    contb=1;
    for iby=5:round(size(orient_image,2)/blksze)-offset
        block=orient_image(centrx-offset:centrx+offset,centry-offset:centry+offset);
        aux=-20;
        main_orient=0;
        for ii=1:prod(size(block));
            aux2=length(find(block(:)==block(ii)));
            if aux2>aux;
                main_orient=block(ii);
                aux=aux2;
            end;
        end;
        MainOrientation(conta,contb)=main_orient;
        centry=(ini+iby*blksze);
        contb=contb+1;
    end
    centrx=(ini+ibx*blksze);
    conta=conta+1;
end
% imagesc(MainOrientation)
% plotridgeorient( MainOrientation,5, double(imresize(img,size(MainOrientation))), 2)

MainOrientation=medfilt2(double(MainOrientation));

sing_points=zeros(size(MainOrientation));
for ibx=2:size(MainOrientation,1)-1
    for iby=2:size(MainOrientation,2)-1
        block=MainOrientation(ibx:ibx+1,iby:iby+1);
        
        if length(find(block(1)==block(:)))+length(find(block(2)==block(:)))+length(find(block(3)==block(:)))<5
            
            [a,blockN(1)]=find(block(1)==orients);[a,blockN(2)]=find(block(2)==orients);[a,blockN(3)]=find(block(3)==orients);[a,blockN(4)]=find(block(4)==orients);
            
            
            OD(1)=8-abs(blockN(1)-blockN(2)); OD(2)=8-abs(blockN(1)-blockN(3)); OD(3)=8-abs(blockN(1)-blockN(4));
            OD(4)=8-abs(blockN(2)-blockN(3)); OD(5)=8-abs(blockN(2)-blockN(4));
            OD(6)=8-abs(blockN(3)-blockN(4));
            
            if length(find(OD>3))>0
                
                if OD(1)>2 | OD(6)>2
                    
                    [inda,indb]=min(block(:));
                    
                    if indb==1; a=1;b=3;c=4; end;
                    if indb==2; a=2;b=1;c=3; end;
                    if indb==3; a=3;b=4;c=2; end;
                    if indb==4; a=4;b=2;c=1; end;
                    A=block(a); B=block(b); C=block(c);
                    
                    if indb==1; b=2;c=4; end;
                    if indb==2; b=4;c=3; end;
                    if indb==3; b=1;c=2; end;
                    if indb==4; b=3;c=1; end;
                    D=block(b); E=block(c);
                    
                    if A<B<C
                        if A<D<E
                        else
                            sing_points(ibx,iby)=1; %LOOP
                        end
                    else
                        sing_points(ibx,iby)=2; %DELTA
                    end
                end
            end
        end
        
    end
    
end

% delta_location2=round(delta_location./(blksze+0.1));
% delta_location2=round(delta_location2);
offset=1;
sing_points2=zeros(size(MainOrientation));
for ibx=offset+1:size(MainOrientation,1)-offset-1
    for iby=offset+1:size(MainOrientation,2)-offset-1
        
        D=[];   
        for iang1=-offset:offset:offset
            for iang2=-offset:offset:offset
                if abs(iang1)+abs(iang2)>0
                    D(end+1)=MainOrientation(ibx+iang1,iby+iang2);
                end
            end
        end
        DP=pi/(sum(abs(D-D(1))).*2);
        
        if abs(DP-1)<0.05           
            sing_points2(ibx,iby)=2; %DELTA
        end       
        
    end
end


% plotridgeorient( MainOrientation,2, double(imresize(img,size(MainOrientation))), 2)
show(imresize(adapthisteq(img),size(MainOrientation)));
hold on
Delta_mask=Ideltas;
Delta_mask(Ideltas>1)=1;
Reli_mask=zeros(size(reliability));
Reli_mask(reliability>0.8)=1;
sing_points=sing_points.*im2bw(imresize(Delta_mask,size(sing_points))).*im2bw(imresize(Reli_mask,size(sing_points)));
sing_points2=sing_points2.*im2bw(imresize(Delta_mask,size(sing_points))).*im2bw(imresize(Reli_mask,size(sing_points)));
for ibx=2:size(MainOrientation,1)-1
    for iby=2:size(MainOrientation,2)-1
        if sing_points(ibx,iby)==2
            plot(iby,ibx,'MarkerSize',4,'Marker','square','LineWidth',3,'Color',[1 0 0]);
        elseif sing_points(ibx,iby)==1
%             plot(iby,ibx,'MarkerSize',4,'Marker','square','LineWidth',3,'Color',[0 1 0]);
        end
        
        if sing_points2(ibx,iby)==2
            plot(iby,ibx,'MarkerSize',4,'Marker','square','LineWidth',3,'Color',[0 1 0]);
        end        
    end
end

delta_location2=round(delta_location./(blksze+0.1));
if delta_location2(1,1)>30
    plot(delta_location2(1,1),delta_location2(1,2),'MarkerSize',8,'Marker','^','LineWidth',2,'LineStyle','none','Color',[0 0 1]);
end
if delta_location2(2,1)>30
    plot(delta_location2(2,1),delta_location2(2,2),'MarkerSize',8,'Marker','^','LineWidth',2,'LineStyle','none','Color',[0 0 1]);
end
if delta_location2(3,1)>30
    plot(delta_location2(3,1),delta_location2(3,2),'MarkerSize',8,'Marker','^','LineWidth',2,'LineStyle','none','Color',[0 0 1]);
end
if delta_location2(4,1)>30
    plot(delta_location2(4,1),delta_location2(4,2),'MarkerSize',8,'Marker','^','LineWidth',2,'LineStyle','none','Color',[0 0 1]);
    
end

% I1=img(round(delta_location(1,2))-150:round(delta_location(1,2))+150,round(delta_location(1,1))-150:round(delta_location(1,1))+150);
% imshow(I1)
% 
% I1=MainOrientation(round(delta_location2(1,2))-20:round(delta_location2(1,2))+20,round(delta_location2(1,1))-20:round(delta_location2(1,1))+20);
% imagesc(I1)
% delta_location2=round(delta_location./(blksze+0.1));
% delta_location2=round(delta_location2);
% D=[];
% offset=3;
% for iang1=-offset:offset:offset
%     for iang2=-offset:offset:offset
%         if abs(iang1)+abs(iang2)>0
%             D(end+1)=MainOrientation(delta_location2(1,2)+iang1,delta_location2(2,2)+iang2);
%         end
%     end    
% end
% DP=pi/(sum(abs(D-D(1))).*2)

% %Validación por k-means
% for ibx=2:size(MainOrientation,1)-1
%     for iby=2:size(MainOrientation,2)-1
%         if sing_points(ibx,iby)==2
%             try
%                 I1=MainOrientation(ibx-10:ibx+10,iby-10:iby+10);
%                 
%                 ab = double(I1);
%                 nrows = size(ab,1);
%                 ncols = size(ab,2);
%                 ab = reshape(ab,nrows*ncols,1);
%                 
%                 nColors = 3;
%                 % repeat the clustering 3 times to avoid local minima
%                 [cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
%                     'Replicates',3);
%                 
%                 pixel_labels = reshape(cluster_idx,nrows,ncols);
%                 imshow(pixel_labels,[]), title('image labeled by cluster index');
%                 pause()
%                 dpixel=zeros(size(pixel_labels));
%                 dpixel(pixel_labels==1)=1;
%                 dpixel1=dpixel-imerode(dpixel,ones(2,2));
%                 
%                 dpixel=zeros(size(pixel_labels));
%                 dpixel(pixel_labels==2)=1;
%                 dpixel2=dpixel-imerode(dpixel,ones(2,2));
%                 
%                 dpixel=zeros(size(pixel_labels));
%                 dpixel(pixel_labels==3)=1;
%                 dpixel3=dpixel-imerode(dpixel,ones(2,2));
%                 
%                 dpixel=dpixel1+dpixel2+dpixel3;
%                 dpixel(dpixel>0)=1;
%                 imshow(dpixel);
%                 
%                 %                          dpixel=diff(pixel_labels);
%                 dpixel(dpixel>0)=1;
%                 imshow(dpixel);
%                 
%                 
%                 
%                 %                         plot(iby,ibx,'MarkerSize',4,'Marker','square','LineWidth',3,'Color',[0 1 0]);
%             end
%         end
%     end
% end
% 
% 
% 

iusu=1;
delta=1;

IROI=imread(['..\Ienhaced\interd_',num2str(iusu),'_',num2str(2),'.jpg']);
img=IROI(1:1:end,1:1:end,1);
blksze = 18; thresh = 0.1;
[cimg, oimg2,fimg,bwimg,eimg,enhimg]=fft_enhance_cubs(img, blksze);

delta_location=delta_matrix{iusu};
delta_location2=delta_location/2;
enhimg2=adapthisteq(enhimg(1:2:end,1:2:end));

I1=enhimg2(round(delta_location2(delta,2))-30:round(delta_location2(delta,2))+30,round(delta_location2(delta,1))-30:round(delta_location2(delta,1))+30);
imshow(I1)

addpath('.\sift');
NumSpatial=6;
NumOrient=8; 
threshold1=0.0000025; 
cont=1;
[frames_delta{cont},descr_delta{cont},gss1,dogss1] = sift(I1(1:2:end,1:2:end),'Threshold',threshold1,'BoundaryPoint',0,'NumOrientbins',NumOrient,'NumSpatialBins',NumSpatial);%'EdgeThreshold',15);
Igallery{cont}=I1(1:2:end,1:2:end);

save param_sift_deltas.mat frames_delta descr_delta Igallery;


load param_sift_deltas.mat

iusu=4;

IROI=imread(['..\Ienhaced\interd_',num2str(iusu),'_',num2str(2),'.jpg']);
img=IROI(1:1:end,1:1:end,1);
blksze = 18; thresh = 0.1;
[cimg, oimg2,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(img, blksze);

I1=adapthisteq(enhimg(1:2:end,1:2:end));

% I1=enhimg2(round(delta_location2(delta,2))-50:round(delta_location2(delta,2))+50,round(delta_location2(delta,1))-50:round(delta_location2(delta,1))+50);
% imshow(I1)

[frames_delta_test,descr_delta_test,gss1,dogss1] = sift(I1(1:2:end,1:2:end),'Threshold',threshold1,'BoundaryPoint',0,'NumOrientbins',NumOrient,'NumSpatialBins',NumSpatial);%'EdgeThreshold',15);
Itest=I1(1:2:end,1:2:end);

for iss=1:1
    descrt1=uint8(512*descr_delta_test);
    descrt2=uint8(512*descr_delta{iss});
    
    framesa=frames_delta_test;
    framesb=frames_delta{iss};
    
    matches=siftmatch(descrt1,descrt2,1.5);
    close all;
    
    I1=Igallery{iss};
    I2=Itest;
    plotmatches(I2, I1,framesa,framesb,matches); %Esto muestra cuales son los matches y donde están. Es importante para saber donde está encontrando coincidencias, donde está la información discriminante
%     pause();
end


            