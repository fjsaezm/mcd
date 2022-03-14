close all
clear all
clc

%BiosecurIDparameters matrix with: 50 (users) x 16 (signatures/user) x 9
%params (x,y,p), its derivatives and second derivatives
BiosecurIDparameters=ones(50,16,9);

genuine_signs = [1,2,6,7];

n_users = 50;

for user=1:n_users
    
    for session = 1:4

        for sign_genuine = 1:4
            
            %This is how to load the signatures:  
            BiosecurID=load(['./DB/u10', sprintf('%02d',user) , ...
                                's000', num2str(session), '_sg000', ...
                                num2str(genuine_signs(sign_genuine)), '.mat']);
           
            % Save parameters
            sign_idx = (session - 1)*4 + sign_genuine;
            BiosecurIDparameters(user, sign_idx, 1:3) = [BiosecurID.x, BiosecurID.y, BiosecurID.p];
            % Compute gradients and assign
            dx = gradient(BiosecurID.x);
            dy = gradient(BiosecurID.y);
            dp = gradient(BiosecurID.p);
            BiosecurIDparameters(user, sign_idx, 4:6) = [dx,dy,dp];

            
            % Compute second derivatives
            ddxx = gradient(dx);
            ddyy = gradient(dy);
            ddpp = gradient(dp);
            BiosecurIDparameters(user, sign_idx, 7:9) = [ddxx,ddyy,ddpp];

        end
        
    end

end


save('BiosecurIDparametersDTW','BiosecurIDparameters');
