function Score=Matcher(test,Model)
% Computes the euclidean distance between
% Test and model
% Equivalently, we can compute the norm of the difference
    Score = norm(test-model);
end