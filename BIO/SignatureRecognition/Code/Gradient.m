function grad=Gradient(a)
% Compute the gradient of a discrete time signal
    grad = a(2:length(a)) - a(1:length(a)-1);
end