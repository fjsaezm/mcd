

close all
clear all
clc

%BiosecurIDparameters matrix with: 50 (users) x 16 (signatures/user) x 4 (params)
BiosecurIDparameters=ones(50,16,4);

n_users = 50;

for user=1:n_users
    
    for session = [1,2,3,4]

        for sign_genuine = [1,2,6,7]
            
            %This is how to load the signatures:  
            BiosecurID=load(['./DB/u10', sprintf('%02d',user) ,'s000', num2str(session), '_sg000', num2str(sign_genuine), '.mat']);
           
            x=BiosecurID.x;
            y=BiosecurID.y;
            p=BiosecurID.p;
        end
        
    end

end



%YOUR CODE       
            
            
            
            

save('BiosecurIDparameters','BiosecurIDparameters');
