function Score=Matcher(test,Model)
% Computes the euclidean distance between
% Test and model
% Equivalently, we can compute the norm of the difference

    N = size(Model,1);
    scores = zeros(1,N);
    for i=1:N
        scores(i) = norm(test-Model(i,:));
    end
    Score = mean(scores);
end