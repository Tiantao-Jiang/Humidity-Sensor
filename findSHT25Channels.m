function channels = findSHT25Channels(controller)
% findSHT25Channels  Scan all 15 cascaded channels and return those with SHT25
%   controller : Initialized ni845x controller object
%   returns:
%     channels  : Row vector of channel indices (0–14) where an SHT25 was found

    SHT_ADDR = hex2dec('40');  % 7‑bit I2C address of SHT25
    channels = [];             % Initialize empty list

    % Helper to normalize scanI2CBus output to numeric array
    function nums = normalize(addrs)
        if iscell(addrs)
            nums = cellfun(@(x) sscanf(x, '%x'), addrs);
        elseif isstring(addrs)
            nums = arrayfun(@(s) sscanf(s, '%x'), addrs);
        else
            nums = addrs;
        end
    end

    for idx = 0:14
        % Select the PCA9548A sub-channel for this sensor index
        selectSensor(controller, idx);
        pause(0.01);           % Allow bus to settle
        
        % Scan the I2C bus for device addresses and normalize
        rawAddrs = scanI2CBus(controller);
        addrs = normalize(rawAddrs);
        
        % If the SHT25 address is present, record this channel
        if any(addrs == SHT_ADDR)
            channels(end+1) = idx; %#ok<AGROW>
        end
    end

    % Disable all channels on both multiplexers when done
    closeAllPcaChannel(controller)
    
end
