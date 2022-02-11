function [out]=radio2(tx,ty,qx,qy)

rad=15;   %15  
vectorx1=[];
vectory1=[];
vectorx2=[];
vectory2=[];
emparejados=0;


for i=1:1:length(tx)
    
    dist=sqrt((tx(i)-qx).^2+(ty(i)-qy).^2);
    valor=min(dist);                        % el valor del minimo
    indice=find(dist==valor);               % posicion de la minima
        
    if (valor < rad)
            
        vectorx1=[vectorx1 tx(i)];
        vectory1=[vectory1 ty(i)];
        vectorx2=[vectorx2 qx(indice)];
        vectory2=[vectory2 qy(indice)];
        
        qx(indice)=1000;
        qy(indice)=1000;
        emparejados=emparejados+1;
            
    end
end

out=(2*emparejados)/(length(tx)+length(qx));


            