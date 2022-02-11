function [x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14, t, num] = recorte (inicio,indice)

D=dir;
offset=8;
for i=inicio:(inicio+13)
    I=imread(D(i+offset).name);
        
    Ic=imcrop(I,[775 370 299 249]);             % Esta linea recorta la imagen
 
    imwrite(Ic,['..\imagenesc\' D(i+offset).name]);   % Esta guarda lo recortado con el mismo nombre en IMGc
    [x,y,t(i-(inicio-1))]=conHough(Ic);
    num(i-(inicio-1))=length(x);
    
    eval(['x' num2str(i-(inicio-1)) ' = x;']);
    eval(['y' num2str(i-(inicio-1)) ' = y;']);
    
end
