


genuine_signs = [1,2,6,7];

n_users = 50;


mat=load('BiosecurIDparametersDTW.mat');
BiosecurIDparameters=mat.BiosecurIDparameters;

maxes = zeros(1,9);

iterations = 0;
for i=1:9

    m = 0;

    for user=1:n_users
    
        for sign = 1:16
   
              m_iter = max(BiosecurIDparameters{user}{sign}{i});
              m = max(m_iter,m);

        end
    end
    maxes(i) = m;
end

%normalize stage
for i=1:9
    for user=1:n_users
    
        for sign = 1:16
   
              BiosecurIDparameters{user}{sign}{i} = BiosecurIDparameters{user}{sign}{i}/maxes(i);

        end
    end
end

save('BiosecurIDparametersDTWNormalized','BiosecurIDparameters');