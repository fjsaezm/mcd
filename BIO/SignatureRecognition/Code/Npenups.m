function Npu = Npenups(p)
     % Returns number of times that the pen is 
     % lifted from the device
    Npu = 0;

    % Find index where pressure is zero
    index = find(p == 0);

    % For each of those index
    for i = index
        % If previous value is not zero, there
        % was a pen-up
        if p(i-1) ~= 0
            Npu = Npu + 1;
        end
    end
end
