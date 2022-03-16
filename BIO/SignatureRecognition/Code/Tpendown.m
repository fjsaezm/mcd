function Tpd = Tpendown(p)
    % Returns percentage of time that the pen is
    % used

    % Take p where p > 0 and then sum ones
    % Percentage
    % We do not need to use the frequence sampling
    Tpd = sum(p > 0)/length(p);
end
