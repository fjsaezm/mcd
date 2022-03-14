close all
clear all
clc

addpath('DetPlots\')

%load de signature parameters
mat=load('BiosecurIDparameters.mat');
BiosecurIDparameters=mat.BiosecurIDparameters;

%obtain size of users and signatures/user
usuarios=size(BiosecurIDparameters,1);
firmas=size(BiosecurIDparameters,2);

%% GENUINE SCORES
i=1; n=1;

GenuineScores=cell(1,3);
for N=[1 4 12]
    for us=1:usuarios
            %Extract the user model
            modelo=BiosecurIDparameters(us,1:N,:);
            modelo=reshape(modelo,N,4);

            for n_test=N+1:firmas   
                %Test signatures: remaining signatures of the user
                test=BiosecurIDparameters(us,n_test,:);
                test=reshape(test,1,4);
                Score = Matcher (test, modelo);
                GenuineScores{n}(us,i)= Score;
                i=i+1;

            end
        i=1;
    end
    n=n+1;
end


% Apply desired normalization
GenuineScores_1= 1./ (GenuineScores{1}+ 0.00000001);
GenuineScores_4= 1 ./ (GenuineScores{2} + 0.00000001);
GenuineScores_12= 1 ./ (GenuineScores{3} + 0.00000001);


%% IMPOSTOR SCORES

i=1; n=1;

ImpostorScores=cell(1,3);
for N=[1 4 12]
    for us=1:usuarios
            %Extract the user model
            modelo=BiosecurIDparameters(us,1:N,:);
            modelo=reshape(modelo,N,4);

            for n_test=1:usuarios 
                if (n_test~=us) %the score is only computed using the other users
                    %First signature of the other user
                    test=BiosecurIDparameters(n_test,1,:); %Always the first signature
                    test=reshape(test,1,4);
                    Score = Matcher (test, modelo);
                    ImpostorScores{n}(us,i)= Score; %50x49 for any N
                    i=i+1;
                end
            end
        i=1;
    end
    n=n+1;
end

ImpostorScores_1= 1 ./ (ImpostorScores{1} + 0.00000001);
ImpostorScores_4= 1./ (ImpostorScores{2} + 0.00000001);
ImpostorScores_12= 1./(ImpostorScores{3} + 0.00000001);


%So far, you have obtained the similarity distance between signatures (values close to
%0 for genuine comparisons and higher for impostor comparisons). However,
%we want to obtain the SCORE (higher for genuine comparisons than for
%impostor comparisons).

% YOUR CODE


figure;
[EER1,DCF_opt1,ThresEER1]=Eval_Det(GenuineScores_1(:)',ImpostorScores_1(:)','b')
figure;
[EER4,DCF_opt4,ThresEER4]=Eval_Det(GenuineScores_4(:)',ImpostorScores_4(:)','b')
figure;
[EER12,DCF_opt12,ThresEER12]=Eval_Det(GenuineScores_12(:)',ImpostorScores_12(:)','b')


