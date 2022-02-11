function [repite] = reloj (in,valor)

m=in;
vecino=[];
repite=0;

long=size(in);
a=long(1);
b=long(2);
m(2:length(a)-1,2:length(b)-1)=0;

for j=1:b
    vecino=[vecino m(1,j)];
end
for i=2:a
    vecino=[vecino m(i,b)];
end
for j=(b-1):-1:1
    vecino=[vecino m(a,j)];
end
for i=(a-1):-1:1
    vecino=[vecino m(i,1)];
end

for i=1:(length(vecino)-1)
    
    transicion=double(vecino(i))-double(vecino(i+1));
    if transicion == -valor
        repite=repite+1;
    end
end
        
        
        
        
    