% -------------------------------------------------------------------
%    FASE DE RECOPILACION DE PARAMETROS A PARTIR DE LAS IMAGENES
% -------------------------------------------------------------------

%a) RECORTE DE IMAGENES en paso de 14
warning off
minutiaes=[];
orientation_matrix=[];
delta_matrix=[];
cont=10;
for iusu=13:220
    fprintf(['Features Extraction User ',num2str(iusu),'\n'])
    for it=1:10
        try
%             fname=['C:\Aythami\DactiloPalmar\BBDD\',num2str(iusu,'%3.3d'),'\',num2str(iusu,'%3.3d'),'.',num2str(it,'%3.3d'),'.jpg'];
%             IROI=imread(fname);
%         IROI=imread(['..\Ienhaced\interd_',num2str(iusu),'_',num2str(ir),'.jpg']);     
            IROI=imread(['..\ROI\roi_',num2str(iusu),'_',num2str(it),'.jpg']);            
%             img=IROI(40:end-40,200:end-100,2);%Este es el bueno
            img=IROI(1:1:end,1:1:end,1);%(20:end-20,20:end-20,2);
%             
%             imshow(adapthisteq(rgb2gray(IROI)))
%             title(['C:\Aythami\DactiloPalmar\BBDD\',num2str(iusu,'%3.3d'),'\',num2str(iusu,'%3.3d'),'.',num2str(it,'%3.3d'),'.jpg']);
%             pause()
            minutiaes{iusu,it} = aytha_conHough(img);
%             
%             blksze = 16; thresh = 0.1;
%             [normim, mask] = ridgesegment((img), blksze, thresh);
%             show(normim,1);
%             [cimg2, oimg,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs((img), -1);
%             enhimg=medfilt2(enhimg); imshow(img); figure; imshow(enhimg)
% % %             
% %             
%             [orientim, reliability] = ridgeorient(enhimg, 1, 5, 5);
%             plotridgeorient(orientim, 20, double(adapthisteq(img)), 2)
%             drawnow
%             orientation_matrix{iusu,1}=orientim;
%             orientation_matrix{iusu,2}=reliability;
                    
%                 imshow(adapthisteq(rgb2gray(IROI)))
%             loop_matrix{iusu}=ginput(2);

%             close all;
%             fprintf(['Features Extraction User ',num2str(iusu),' Image ',num2str(it),' Number of minutiaes: ',num2str(size(minutiaes{iusu,it}{1},1)),'\n'])
            drawnow;
            close all;
        end
    end
    if rem(iusu,20)==0
        save features_minutiaes_200 minutiaes iusu
%         fname=['orientation_',num2str(cont),'.mat'];
%         eval(['save ',fname,' orientation_matrix']);
%         clear orientation_matrix;
%         orientation_matrix=[];
%         cont=cont+1;
    end
% save loops.mat loop_matrix iusu
end
% fname=['orientation_',num2str(cont),'.mat'];
% eval(['save ',fname,' orientation_matrix']);
% save orientations.mat orientation_matrix

% load deltas.mat
% fname=['C:\Aythami\DactiloPalmar\BBDD\',num2str(15,'%3.3d'),'\',num2str(15,'%3.3d'),'.',num2str(1,'%3.3d'),'.jpg'];
% IROI=imread(fname);
% imshow(adapthisteq(rgb2gray(IROI)))
% hold on;
% for iss=1:190
%     if delta_matrix{iss}(1,1)>150
%         plot(delta_matrix{iss}(1,1),delta_matrix{iss}(1,2),'MarkerSize',7,'Marker','^','LineWidth',2,'LineStyle','none','Color',[0 1 0]);
%     end
%     if delta_matrix{iss}(2,1)>150
%         plot(delta_matrix{iss}(2,1),delta_matrix{iss}(2,2),'MarkerSize',7,'Marker','^','LineWidth',2,'LineStyle','none','Color',[1 0 0]);
%     end
%     if delta_matrix{iss}(3,1)>150
%         plot(delta_matrix{iss}(3,1),delta_matrix{iss}(3,2),'MarkerSize',7,'Marker','^','LineWidth',2,'LineStyle','none','Color',[0 0 1]);
%     end
% end
% 
% clear all
% close all
% load loops.mat
% fname=['C:\Aythami\DactiloPalmar\BBDD\',num2str(15,'%3.3d'),'\',num2str(15,'%3.3d'),'.',num2str(1,'%3.3d'),'.jpg'];
% IROI=imread(fname);
% imshow(adapthisteq(rgb2gray(IROI)))
% hold on;
% for iss=1:220
%     if loop_matrix{iss}(1,1)>150
%         plot(loop_matrix{iss}(1,1),loop_matrix{iss}(1,2),'MarkerSize',7,'Marker','o','LineWidth',2,'LineStyle','none','Color',[1 0 1]);
%     end
%     if loop_matrix{iss}(2,1)>150
%         plot(loop_matrix{iss}(2,1),loop_matrix{iss}(2,2),'MarkerSize',7,'Marker','o','LineWidth',2,'LineStyle','none','Color',[1 0 1]);
%     end    
% end
% 
% clear all
% close all
% load orientation_1.mat
% orientation_mean=zeros(size(orientation_matrix{1,1}));
% for irr=1:10
%     fname=['orientation_',num2str(irr),'.mat'];
%     eval(['load ',fname,' orientation_matrix']);
%     for iusu=(irr-1)*20+1:(irr-1)*20+20
%         orientation_mean=orientation_mean+double(orientation_matrix{iusu,1});
%     end
% end
% 
% load BW_mask
% % BWmask=BWmask(40:end-40,200:end-100);
% plotridgeorient(orientation_mean/190, 30, BWmask, 1)
% drawnow
% 
%  
% % load features_minutiaes 
% for iusu=121:size(minutiaes,1)
%     for it=1:10%size(minutiaes,2)
%         try
%             Iaux=zeros(402,902);
%             for ixx=1:length(minutiaes{iusu,it}{1})
%                 Iaux(minutiaes{iusu,it}{1}(ixx),minutiaes{iusu,it}{2}(ixx))=1;
%             end
%             Iaux2=Iaux.*(minutiaes{iusu,it}{3}>0.80);
%             % imshow(Iaux2)
%             [validas_x,validas_y]=find(Iaux2==1);
%             minutiaes{iusu,it}{1}=validas_x;
%             minutiaes{iusu,it}{2}=validas_y;
%         end
%     end
% end

load features_minutiaes_200
sc_g=[];
sc_i=[];
score_matrix=[];
for iusu=12:size(minutiaes,1)
    for iusu2=1:size(minutiaes,1)
        if iusu==iusu2
            for it=1:5%size(minutiaes,2)
                try
                    for ir=1:5%size(minutiaes,2)
                        if ir~=it %& (sum(minutiaes{iusu,ir}{3}(:)>0.9)/prod(size(minutiaes{iusu,ir}{3})))>0.5
%                             tic
                            score_matrix(iusu,iusu2,it,ir)=Hough(minutiaes{iusu,it}{1}',minutiaes{iusu,it}{2}',minutiaes{iusu2,ir}{1}',minutiaes{iusu2,ir}{2}');
%                             toc
                            if score_matrix(iusu,iusu2,it,ir)>0
                                sc_g(end+1)=score_matrix(iusu,iusu2,it,ir);
                                fprintf(['User ',num2str(iusu),' image ',num2str(it),' vs User ',num2str(iusu2),' image ',num2str(ir),': ',num2str(score_matrix(iusu,iusu2,it,ir)),'\n']);
                            end
                        end
                    end
                end
            end
        end
    end
    save scores_minutiae_200.mat score_matrix iusu sc_g sc_i

end

load features_minutiaes_200
for iusu=1:size(minutiaes,1)
    for iusu2=1:size(minutiaes,1)
        if iusu~=iusu2
            for it=1:5:size(minutiaes,2)
                try
                    for ir=1:5%size(minutiaes,2)
                        %if & (sum(minutiaes{iusu2,ir}{3}(:)>0.9)/prod(size(minutiaes{iusu2,ir}{3})))>0.5
                        score_matrix(iusu,iusu2,it,ir)=Hough(minutiaes{iusu,it}{1}',minutiaes{iusu,it}{2}',minutiaes{iusu2,ir}{1}',minutiaes{iusu2,ir}{2}');
                        if score_matrix(iusu,iusu2,it,ir)>0
                            sc_i(end+1)=score_matrix(iusu,iusu2,it,ir);
                            fprintf(['User ',num2str(iusu),' image ',num2str(it),' vs User ',num2str(iusu2),' image ',num2str(ir),': ',num2str(score_matrix(iusu,iusu2,it,ir)),'\n']);
                        end
                        %end
                    end
                end
            end
        end
        eer_plot
    end
     save scores_minutiae_200.mat score_matrix iusu sc_g sc_i
end

sc_g=[];
sc_i=[];
for iusu=1:size(minutiaes,1)
    for iusu2=1:size(minutiaes,1)
        if iusu==iusu2
            a=1;
            b=1;
        else
            a=1;
            b=3;
        end
        for it=a:b:size(minutiaes,2)
            try
                scores=[];
                for ir=1:5%size(minutiaes,2)
                    scores(end+1)=score_matrix(iusu,iusu2,it,ir);
                end
                if max(scores)>0
                    if iusu==iusu2
                        sc_g(end+1)=max(scores);
                    else
                        sc_i(end+1)=max(scores);
                    end
                end
            end
        end
    end
end
save scores_minutiae_200.mat score_matrix iusu
figure
eer_plot;
