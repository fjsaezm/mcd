function grad=Gradient(a)
% Compute the gradient of a discrete time signal
    shift = a(2:length(a)) - a(1:length(a)-1);
    grad = [a(1) shift];
end