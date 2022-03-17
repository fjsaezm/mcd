function Score=MatcherDTW(test,Model)
% Computes the average of the SingleMatch Score
% Between the input and the N comparisons

    N = size(Model,1);
    scores = zeros(1,N);
    for i=1:N
        Model{i};
        scores(i) = SingleMatcherDTW(test,Model{i});
    end
    Score = mean(scores);
end