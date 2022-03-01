function [EER] = compute_eer_distance (X_train, X_test, ...
                                        y_train, y_test, ...
                                        Train, Test,...
                                        plot_eer)

    TargetScores=[];
    NonTargetScores=[];
    
    for i=1:numel(y_test) %For each Test image
    
        for j=1:numel(y_train) %Comparison with each Training image
                
            my_distance(j)=mean(abs(X_test(i,:)-X_train(j,:))); %Compute the distance measure
            
            if(y_test(i,:)==y_train(j,:)) %if it's a genuine comparison
                LabelTest(j)=1;
                
            else % otherwise
                LabelTest(j)=0;
            end
            
        end
        
        %The final score is the min of the 6 comparisons of 
        % each Test image against the training images of each user
        
        for k=1:Train:numel(my_distance)
            my_distanceRed(k)=min(my_distance(k:k+Train-1)); %Extract the scores of the N training signatures and select the min
            
            if LabelTest(k)==1 %target score            
                TargetScores=[TargetScores, my_distanceRed(k)];
            else %non target score 
                NonTargetScores=[NonTargetScores, my_distanceRed(k)];
            end
            
        end
        
        
    end
    
    %Multiply by -1 to have higher values for genuine comparisons, as we have a distance computation. 
    % With other type of classifier this wouldn't be necessary.
    
    TargetScores=-TargetScores;
    NonTargetScores=-NonTargetScores;
    
    %save('ParametrizaATT','TargetScores','NonTargetScores');
    
    [EER]=Eval_Det(TargetScores,NonTargetScores,'b',plot_eer); %Plot Det curve

end