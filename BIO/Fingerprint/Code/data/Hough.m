function [out]=Hough(tx,ty,qx,qy)
%% Minutiae Matching based on the Hough transform

dist=0;

for i=1:1:length(tx)
    
    desp_x=tx(i)-qx;
    desp_y=ty(i)-qy;
    
    for j=1:1:length(desp_x)
        nuevo_qx=qx + desp_x(j);
        nuevo_qy=qy + desp_y(j);
        
        dist(i,j)=radio2(tx,ty,nuevo_qx,nuevo_qy);

    end
end

out=max(max(dist));
