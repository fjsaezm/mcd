% -------------------------------------------------------------------
%    FASE DE RECOPILACION DE PARAMETROS A PARTIR DE LAS IMAGENES
% -------------------------------------------------------------------

%a) RECORTE DE IMAGENES en paso de 14
warning off
minutiaes=[];
orientation_matrix=[];
delta_matrix=[];
cont=10;
load BW_mask.mat
load Ideltas_mask.mat Ideltas 
load deltas2.mat

for iusu=1:20
    fprintf(['Features Extraction User ',num2str(iusu),'\n'])
    for ir=2:5
        try
%             fname=['C:\Aythami\DactiloPalmar\BBDD\',num2str(iusu,'%3.3d'),'\',num2str(iusu,'%3.3d'),'.',num2str(it,'%3.3d'),'.jpg'];
%             IROI=imread(fname);
        IROI=imread(['..\Ienhaced\interd_',num2str(iusu),'_',num2str(ir),'.jpg']);     
           
            img=IROI(1:1:end,1:1:end,1);%(20:end-20,20:end-20,2);
%             
%             imshow(adapthisteq(rgb2gray(IROI)))
%             title(['C:\Aythami\DactiloPalmar\BBDD\',num2str(iusu,'%3.3d'),'\',num2str(iusu,'%3.3d'),'.',num2str(it,'%3.3d'),'.jpg']);
%             pause()
%             minutiaes{iusu,it} = aytha_conHough(img);
%             
            blksze = 18; thresh = 0.1;
%             [normim, mask] = ridgesegment((img), blksze, thresh);
%             show(normim,1);
%             [cimg2, oimg,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(adapthisteq(img), -1);
            [cimg, oimg2,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(img, blksze);
%             [cimg2, oimg,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(enhimg, blksze/2);
%             enhimg=medfilt2(enhimg); 
            figure; imshow(enhimg)
            
%             IROI=enhimg(620:1100,300:1500,:);
            
% %             
%            figure 
            [orientim, reliability] = ridgeorient(enhimg, 1, 1, 1);
            plotridgeorient(orientim,20, double(adapthisteq(img)), 2)
            
            if ir==2
                locate_syng(img,orientim,delta_matrix{iusu},reliability)
            else
                locate_syng(img,orientim,[])
            end
            
            drawnow
            orientation_matrix{iusu,ir,1}=orientim;
            orientation_matrix{iusu,ir,2}=reliability;
            orientation_matrix{iusu,ir,3}=enhimg;
                    
%                 imshow(adapthisteq(rgb2gray(IROI)))
%             loop_matrix{iusu}=ginput(2);

%             close all;
%             fprintf(['Features Extraction User ',num2str(iusu),' Image ',num2str(it),' Number of minutiaes: ',num2str(size(minutiaes{iusu,it}{1},1)),'\n'])
            drawnow;
            close all;
        end
    end
    if rem(iusu,20)==0
        save orientations_and_enhaced_images orientation_matrix iusu
%         fname=['orientation_',num2str(cont),'.mat'];
%         eval(['save ',fname,' orientation_matrix']);
%         clear orientation_matrix;
%         orientation_matrix=[];
%         cont=cont+1;
    end
% save loops.mat loop_matrix iusu
end

% clear all
% load orientations_and_enhaced_images
% 
% % blksze2=blksze/2;
% 
% for iusu=1:20
%     fprintf(['Orientation Estimation User ',num2str(iusu),'\n'])
%     for ir=1:5
%         try
%             
%             %             orientation_matrix{iusu,ir,1}=orientim;
%             %             orientation_matrix{iusu,ir,2}=reliability;
%             %             orientation_matrix{iusu,ir,3}=enhimg;
%             
%             %             fun = inline('aux=0; main_orient=0; for ii=1:prod(size(x)); aux2=length(find(x(:)==x(ii))); if aux2>aux; main_orient=x(ii); aux=aux2; end; end;');
%             %
%             %             MainOrientation = blkproc(orientation_matrix{iusu,ir,1}, [blksze blksze], fun);
%             load Ideltas_mask.mat Ideltas 
%             blksze=2;
%             orients=[0:pi/8:pi];
%             orient_image=zeros(size(orientation_matrix{iusu,ir,1}));
%             for ibx=1:size(orientation_matrix{iusu,ir,1},1)
%                 for iby=1:size(orientation_matrix{iusu,ir,1},2)
%                     [inda,indb]=min(abs(orients-orientation_matrix{iusu,ir,1}(ibx,iby)));
%                     if indb==9
%                         indb=1;
%                     end
%                     orient_image(ibx,iby)=orients(indb(1));
%                 end
%             end
%             plotridgeorient( orient_image,20, double(adapthisteq(img)), 1)
%             
%             MainOrientation=[];
%             blksze=5;
%             ini=blksze;
%             conta=1;
%             centrx=ini;
%             for ibx=5:round(size(orient_image,1)/blksze)-5
%                 centry=ini;
%                 contb=1;
%                 for iby=5:round(size(orient_image,2)/blksze)-5
%                     block=orient_image(centrx-2:centrx+2,centry-2:centry+2);
%                     aux=-20;
%                     main_orient=0;
%                     for ii=1:prod(size(block));
%                         aux2=length(find(block(:)==block(ii)));
%                         if aux2>aux;
%                             main_orient=block(ii);
%                             aux=aux2;
%                         end;
%                     end;
%                     MainOrientation(conta,contb)=main_orient;
%                     centry=(ini+iby*blksze);
%                     contb=contb+1;
%                 end
%                 centrx=(ini+ibx*blksze);
%                 conta=conta+1;
%             end
%             imagesc(MainOrientation)
%             plotridgeorient( MainOrientation,5, double(imresize(img,size(MainOrientation))), 2)
%             
%             MainOrientation=medfilt2(double(MainOrientation));
%             
%             sing_points=zeros(size(MainOrientation));
%             for ibx=2:size(MainOrientation,1)-1
%                 for iby=2:size(MainOrientation,2)-1
%                     block=MainOrientation(ibx:ibx+1,iby:iby+1);
%                     
%                     if length(find(block(1)==block(:)))+length(find(block(2)==block(:)))+length(find(block(3)==block(:)))<5
%                         
%                         [a,blockN(1)]=find(block(1)==orients);[a,blockN(2)]=find(block(2)==orients);[a,blockN(3)]=find(block(3)==orients);[a,blockN(4)]=find(block(4)==orients);
%                         
%                         
%                         OD(1)=8-abs(blockN(1)-blockN(2)); OD(2)=8-abs(blockN(1)-blockN(3)); OD(3)=8-abs(blockN(1)-blockN(4));
%                         OD(4)=8-abs(blockN(2)-blockN(3)); OD(5)=8-abs(blockN(2)-blockN(4));
%                         OD(6)=8-abs(blockN(3)-blockN(4));
%                         
%                         if length(find(OD>3))>0
%                             
%                             if OD(1)>2 | OD(6)>2
%                                 
%                                 [inda,indb]=min(block(:));
%                                 
%                                 if indb==1; a=1;b=3;c=4; end;
%                                 if indb==2; a=2;b=1;c=3; end;
%                                 if indb==3; a=3;b=4;c=2; end;
%                                 if indb==4; a=4;b=2;c=1; end;
%                                 A=block(a); B=block(b); C=block(c);
%                                 
%                                 if indb==1; b=2;c=4; end;
%                                 if indb==2; b=4;c=3; end;
%                                 if indb==3; b=1;c=2; end;
%                                 if indb==4; b=3;c=1; end;
%                                 D=block(b); E=block(c);    
%                                 
%                                 if A<B<C
%                                     if A<D<E
%                                     else
%                                         sing_points(ibx,iby)=1; %LOOP
%                                     end
%                                 else
%                                     sing_points(ibx,iby)=2; %DELTA
%                                 end
%                             end
%                         end
%                     end
%                     
%                 end
%                 
%             end
%             
%             
%             plotridgeorient( MainOrientation,2, double(imresize(img,size(MainOrientation))), 2)
%             hold on
%             Delta_mask=Ideltas; 
%             Delta_mask(Ideltas>1)=1;
%             sing_points=sing_points.*im2bw(imresize(Delta_mask,size(sing_points)));
%             for ibx=2:size(MainOrientation,1)-1
%                 for iby=2:size(MainOrientation,2)-1
%                     if sing_points(ibx,iby)==2  
%                        plot(iby,ibx,'MarkerSize',4,'Marker','square','LineWidth',3,'Color',[1 0 0]);
%                     elseif sing_points(ibx,iby)==1
%                         plot(iby,ibx,'MarkerSize',4,'Marker','square','LineWidth',3,'Color',[0 1 0]); 
%                     end
%                 end
%             end
%             
%             
%             %Validación por k-means
%             for ibx=2:size(MainOrientation,1)-1
%                 for iby=2:size(MainOrientation,2)-1
%                     if sing_points(ibx,iby)==2
%                         try
%                         I1=MainOrientation(ibx-10:ibx+10,iby-10:iby+10);
%                        
%                         ab = double(I1);
%                         nrows = size(ab,1);
%                         ncols = size(ab,2);
%                         ab = reshape(ab,nrows*ncols,1);
%                         
%                         nColors = 3;
%                         % repeat the clustering 3 times to avoid local minima
%                         [cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
%                             'Replicates',3);
%                         
%                         pixel_labels = reshape(cluster_idx,nrows,ncols);
%                         imshow(pixel_labels,[]), title('image labeled by cluster index');
%                          pause()
%                         dpixel=zeros(size(pixel_labels));
%                         dpixel(pixel_labels==1)=1;
%                          dpixel1=dpixel-imerode(dpixel,ones(2,2));
%                         
%                           dpixel=zeros(size(pixel_labels));
%                         dpixel(pixel_labels==2)=1;
%                          dpixel2=dpixel-imerode(dpixel,ones(2,2));
%                          
%                           dpixel=zeros(size(pixel_labels));
%                         dpixel(pixel_labels==3)=1;
%                          dpixel3=dpixel-imerode(dpixel,ones(2,2));
%                          
%                          dpixel=dpixel1+dpixel2+dpixel3;
%                          dpixel(dpixel>0)=1;
%                         imshow(dpixel);
%                         
% %                          dpixel=diff(pixel_labels);
%                         dpixel(dpixel>0)=1;
%                         imshow(dpixel);
%                         
%                        
%                         
% %                         plot(iby,ibx,'MarkerSize',4,'Marker','square','LineWidth',3,'Color',[0 1 0]);
%                         end
%                     end
%                 end
%             end
%             
%             
%             
%             
%             
%             
%                 
%                 
%                 
%                 
%                 
%                 
%                 
%             
%         end
%     end
%     %         save orientations_and_enhaced_images orientation_matrix iusu
%     
%     % save loops.mat loop_matrix iusu
% end
% 
%  
% aux=0;
% main_orient=0;
% for ii=1:prod(size(a)); 
%     aux2=length(find(a(:)==a(ii))); 
%     if aux2>aux;
%         main_orient=a(ii);
%         aux=aux2; 
%     end; 
% end;
% main_orient
