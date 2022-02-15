function [minucias, minucias_x, minucias_y, time] = extraer (in,ventana,marg)

tic;
long= size(in);
a=long(1);
b=long(2);
margen=marg;%   % el margen a dejar desde el borde hasta el comienzo de la busquedad.
                % y puesto que la mascara es de 3x3, entonces, el margen debe incluir un pixel mas.
                % Por lo tanto, 56 + 1= 57.
minucias = [];
minucias_x = [];
minucias_y = [];
                
if nargin < 2
    ventana =3;
end

for i=margen:a-margen
    for j=margen:b-margen
        
        pixel=in(i,j);
        count=0;
        if pixel == 1 
            if ventana == 3
                vecino=[in(i-1,j-1) in(i-1,j) in(i-1,j+1); in(i,j-1) 0 in(i,j+1); in(i+1,j-1) in(i+1,j) in(i+1,j+1)];
            else
                if ventana == 5
                    vecino=in(i-2:i+2,j-2:j+2);
                    vecino(2:4,2:4)=0;
                end
            % Pruebas realizadas dice que el 5x5 no es buena solucion.
            end
            Area=sum(vecino(:));

            if Area == 1 
                minucias = [minucias 1 i j];
                minucias_x = [minucias_x i];
                minucias_y = [minucias_y j];
            else
                if Area == 3
                    vecino=[in(i-1,j) in(i-1,j+1) in(i,j+1) in(i+1,j+1) in(i+1,j) in(i+1,j-1) in(i,j-1) in(i-1,j-1) in(i-1,j)];
                    for k=1:8
                        valor=double(vecino(k))-double(vecino(k+1));
                        if valor == -1                                  %¡¡¡AQUI ES "-1" PORQUE ESTAMOS TRABAJANDO
                            count=count+1;                              % CON BINARIO Y NO ETIQUETADO !!!!
                        end
                    end
                    
                    if count == 3
                        minucias = [minucias 2 i j];
                        minucias_x = [minucias_x i];
                        minucias_y = [minucias_y j];
                    end
                end
            end
        end
    end
end

time=toc;

%figure,imshow(~in);
%hold on;
%plot(minucias_y, minucias_x, 'rx');
%hold off;
%title('8.Extracion de todas las terminaciones y bifurcaciones dentro del margen');
%xlabel (['Tiempo de computo de la extracion : ',num2str(time)]);
%ylabel (['ventana: ',num2str(ventana) ' margen: ',num2str(marg)]);