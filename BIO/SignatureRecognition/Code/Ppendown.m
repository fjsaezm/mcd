function Ppd = Ppendown(p)
    % Compute mean pressure using positions 
    % Where pen is down (p > 0)
    Ppd = mean(p(p > 0.0) );
end
