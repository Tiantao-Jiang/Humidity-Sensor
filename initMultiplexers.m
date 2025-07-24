function initMultiplexers(controller)
% initMultiplexers   Verify both PCA9548A muxes are present and disable all channels
%   controller : Initialized ni845x controller object
%
% This function will:
%   1. Disable all channels on both muxes.
%   2. Scan the root I2C bus to confirm the first multiplexer (0x70) is present.
%   3. Open channel 0 on the first mux, then scan the downstream bus to confirm
%      the second multiplexer (0x71) is present.
%   4. Finally disable all channels on both muxes again.
%
% Throws an error if either multiplexer is not detected.

    % 7-bit I2C addresses of the two PCA9548A muxes
    ADDR1 = hex2dec('70');
    ADDR2 = hex2dec('71');

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

    % Step 2: Scan the root bus for the first mux
    rootAddrs = normalize(scanI2CBus(controller));
    if ~ismember(ADDR1, rootAddrs)
        error('PCA9548A at address 0x70 not found on the root I2C bus.');
    end

    % Step 3: Open channel 0 on the first mux to reach the second mux
    selectPcaChannel(controller, ADDR1, 0);
    pause(0.01);  % Allow bus to settle
    downstreamAddrs = normalize(scanI2CBus(controller));
    if ~ismember(ADDR2, downstreamAddrs)
        error('PCA9548A at address 0x71 not found on downstream channel 0.');
    end

    % Step 4: Disable all channels again on both muxes
    closeAllPcaChannel(controller)
end
