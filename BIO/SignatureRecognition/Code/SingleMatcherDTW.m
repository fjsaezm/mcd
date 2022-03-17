function Single_Score_DTW=SingleMatcherDTW(test,Model)
% Computes the score using e^{-D/k} where D is the DTW
% distance and k the number of coincident points in the DTW
    N = size(Model,2);
    scores = zeros(1,N);
    for i=1:N
        [D,ix,iy] = dtw(test{i}/max(test{i}),...
                        Model{i}/max(Model{i}));
        k = sum(ix == iy);
        scores(i) = exp(-D/k);
    end
    Single_Score_DTW = mean(scores);
end