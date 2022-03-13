function Tpd = Tpendown(p)
    % Returns percentage of time that the pen is
    % used

    % Take p where p > 0 and then apply
    % Percentage
    Tpd = length(p(p > 0))/length(p);
end
