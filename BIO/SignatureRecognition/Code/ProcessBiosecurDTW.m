close all
clear all
clc

%BiosecurIDparameters matrix with: 50 (users) x 16 (signatures/user) x 9 
% This 9 will be a Cell with x,y,p, derivatives and second derivatives
BiosecurIDparameters=cell(50,16,9);

genuine_signs = [1,2,6,7];

n_users = 50;

for user=1:n_users
    
    for session = 1:4

        for sign_genuine = 1:4
            
            %This is how to load the signatures:  
            BiosecurID=load(['./DB/u10', sprintf('%02d',user) , ...
                                's000', num2str(session), '_sg000', ...
                                num2str(genuine_signs(sign_genuine)), '.mat']);
            % Compute derivatives

            dx = Gradient(BiosecurID.x);
            dy = Gradient(BiosecurID.y);
            dp = Gradient(BiosecurID.p);

            % Compute second derivatives
            ddxx = Gradient(dx);
            ddyy = Gradient(dy);
            ddpp = Gradient(dp);

            % Save parameters
            sign_idx = (session - 1)*4 + sign_genuine;

            BiosecurIDparameters{user}{sign_idx}{1} = BiosecurID.x; 
            BiosecurIDparameters{user}{sign_idx}{2} = BiosecurID.y; 
            BiosecurIDparameters{user}{sign_idx}{3} = BiosecurID.p;


            BiosecurIDparameters{user}{sign_idx}{4} = dx; 
            BiosecurIDparameters{user}{sign_idx}{5} = dy; 
            BiosecurIDparameters{user}{sign_idx}{6} = dp;

            BiosecurIDparameters{user}{sign_idx}{7} = ddxx; 
            BiosecurIDparameters{user}{sign_idx}{8} = ddyy; 
            BiosecurIDparameters{user}{sign_idx}{9} = ddpp;

        end
        
    end

end


save('BiosecurIDparametersDTW','BiosecurIDparameters');
