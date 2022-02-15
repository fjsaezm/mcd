function [out, out_x, out_y,time] = validacion (in, minucias,dist)

tic;
long=size(in);

v=minucias;
W=dist;                
out=[];
out_x=[];
out_y=[];

for i=1:3:length(v)
    try
    if v(i) == 1            % minutiae ending type
    
        x=v(i+1);
        y=v(i+2);
        
        win=in(x-W:x+W, y-W:y+W);               % Clock algorithm aplied around the minuatiae 
        label=bwlabel(win);
        valor=label(W+1,W+1);              
        num=reloj(label,valor);

        if num==1                        
           out=[out v(i) v(i+1) v(i+2)];
           out_x=[out_x v(i+1)];
           out_y=[out_y v(i+2)];
        end
        
    else
        if v(i) == 2        % minutiae bicurfaction type
            x=v(i+1);
            y=v(i+2);
            
            
            win=in(x-W:x+W, y-W:y+W);
            win((W+1)-1:(W+1)+1, (W+1)-1:(W+1)+1) = 0;
            label=bwlabel(win);
            win2=label((W+1)-2:(W+1)+2, (W+1)-2:(W+1)+2);                  
            [r,c]=find(win2 > 0);
            if length(r) >= 3
                valor1=win2(r(1),c(1));
                valor2=win2(r(2),c(2));
                valor3=win2(r(3),c(3));
                num1=reloj(label,valor1);
                num2=reloj(label,valor2);
                num3=reloj(label,valor3);

                if (num1==1&num2==1&num3==1)
                    out=[out v(i) v(i+1) v(i+2)];
                    out_x=[out_x v(i+1)];
                    out_y=[out_y v(i+2)];
                end
            end
        end
    end
    end
end

%----------------------------------------------------------------------
%%Last step, the minimun distance between minutiae must be greater than 8 pixels (to avoid noisy regions).

x=out_x;
y=out_y;
for i=1:length(out_x)
    contador=0;
    for j=1:length(out_x)
        if i~=j
            dist=sqrt(((out_x(i)-out_x(j))^2)+((out_y(i)-out_y(j))^2));
            if dist <= 8 
                x(j)=0;
                y(j)=0;
                contador=contador+1;
            end
        end
    end
    if contador > 0
        x(i)=0;
        y(i)=0;
    end
end
ind=find(x>0);
out_x=x(ind);
ind=find(y>0);
out_y=y(ind);

% ---------------------------------------------------------------

time=toc;
%hold on;
%plot(out_y,out_x, 'go');
%hold off;


%title('Final validated set');
%xlabel (['Tiempo de computo de la validacion : ',num2str(time)]);
%ylabel (['distancia desde el margen: ',num2str(dist)]);
