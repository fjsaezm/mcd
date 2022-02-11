function [score_matrix,sc_g,sc_i]=semejanza(minutiaes)

sc_g=[];
sc_i=[];
score_matrix=[];
for iusu=1:size(minutiaes,1)  
    for iusu2=1:size(minutiaes,1)
        for it=1:size(minutiaes,2)
            for ir=1:size(minutiaes,2)
                if ir~=it
                    score_matrix(iusu,iusu2,it,ir)=Hough(minutiaes{iusu,it}{1},minutiaes{iusu,it}{2},minutiaes{iusu2,ir}{1},minutiaes{iusu2,ir}{2});
                    if iusu==iusu2
                        sc_g(end+1)=score_matrix(iusu,iusu2,it,ir);
                    else
                        sc_i(end+1)=score_matrix(iusu,iusu2,it,ir);
                    end
                    fprintf(['User ',num2str(iusu),' image ',num2str(it),' vs User ',num2str(iusu2),' image ',num2str(ir),': ',num2str(score_matrix(iusu,iusu2,it,ir)),'\n']);
                            
                end
            end
        end
    end
end