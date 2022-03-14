

close all
clear all
clc

%BiosecurIDparameters matrix with: 50 (users) x 16 (signatures/user) x 4 (params)
BiosecurIDparameters=ones(50,16,4);

genuine_signs = [1,2,6,7];

n_users = 50;

for user=1:n_users
    
    for session = 1:4

        for sign_genuine = 1:4
            
            %This is how to load the signatures:  
            BiosecurID=load(['./DB/u10', sprintf('%02d',user) , ...
                                's000', num2str(session), '_sg000', ...
                                num2str(genuine_signs(sign_genuine)), '.mat']);
           
            sign_idx = (session - 1)*4 + sign_genuine;
            BiosecurIDparameters(user, sign_idx, :) = featureExtractor(BiosecurID.x, BiosecurID.y, BiosecurID.p);
        end
        
    end

end


n_bins = 30;

%YOUR CODE       
figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,1), 'Normalization', 'probability');
title("Normalized histogram of Ttotal")
hold off;

figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,1)/length(BiosecurIDparameters(:,:,1)));
title("Normalized histogram of Ttotal")
hold off;
            
figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,2),'Normalization', 'probability');
title("Normalized histogram of Npenups")
hold off;
            
figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,3),'Normalization', 'probability');
title("Normalized histogram of Tpendown")
hold off;
            
figure;
hold on;
h = histogram(BiosecurIDparameters(:,:,4),'Normalization', 'probability');
title("Normalized histogram of Ppendown")
hold off;
            

            
            

save('BiosecurIDparameters','BiosecurIDparameters');
