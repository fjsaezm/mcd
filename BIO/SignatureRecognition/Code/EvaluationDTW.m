close all
clear all
clc

addpath('DetPlots\')

%load de signature parameters
mat=load('BiosecurIDparametersDTW.mat');
BiosecurIDparameters=mat.BiosecurIDparameters;

%obtain size of users and signatures/user
usuarios=size(BiosecurIDparameters,1);
firmas=size(BiosecurIDparameters,2);


%% GENUINE SCORES
i=1; n=1;

GenuineScores=cell(1,3);


for N=[1 4 12]
    for us=1:usuarios
            %Extract the user model, taking the first
            % N signs
            modelo = cell(N,1);
            for i=1:N
                modelo{i} = BiosecurIDparameters{us}{i};
            end


            for n_test=N+1:firmas   
                %Test signatures: remaining signatures of the user
                test=BiosecurIDparameters{us}{n_test};
                Score = MatcherDTW (test, modelo);
                GenuineScores{n}(us,i-N + 1)= Score;
                i=i+1;

            end
        i=1;
    end
    n=n+1;
end


GenuineScores_1 = GenuineScores{1};
GenuineScores_4 = GenuineScores{2};
GenuineScores_12 = GenuineScores{3};




%% IMPOSTOR SCORES

i=1; n=1;

ImpostorScores=cell(1,3);
for N=[1 4 12]
    for us=1:usuarios
            %Extract the user model
            %Extract the user model, taking the first
            % N signs
            modelo = cell(N,1);
            for i=1:N
                modelo{i} = BiosecurIDparameters{us}{i};
            end

            for n_test=1:usuarios 
                if (n_test~=us) %the score is only computed using the other users
                    %First signature of the other user
                    test=BiosecurIDparameters{n_test}{1}; %Always the first signature
                    Score = MatcherDTW (test, modelo);
                    ImpostorScores{n}(us,i - N + 1)= Score; %50x49 for any N
                    i=i+1;
                end
            end
        i=1;
    end
    n=n+1;
end

ImpostorScores_1 = ImpostorScores{1};
ImpostorScores_4 = ImpostorScores{2};
ImpostorScores_12 = ImpostorScores{3};

%So far, you have obtained the similarity distance between signatures (values close to
%0 for genuine comparisons and higher for impostor comparisons). However,
%we want to obtain the SCORE (higher for genuine comparisons than for
%impostor comparisons).



figure;
[EER1,DCF_opt1,ThresEER1]=Eval_Det(GenuineScores_1(:)',ImpostorScores_1(:)','b')
figure;
[EER4,DCF_opt4,ThresEER4]=Eval_Det(GenuineScores_4(:)',ImpostorScores_4(:)','b')
figure;
[EER12,DCF_opt12,ThresEER12]=Eval_Det(GenuineScores_12(:)',ImpostorScores_12(:)','b')


