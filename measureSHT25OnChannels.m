function results = measureSHT25OnChannels(controller, channelList)
% measureSHT25OnChannels  Read SHT25 only on specified channels
%   controller  : ni845x controller object
%   channelList : vector of channel indices (0–14) to read
%  returns:
%   results      : N×1 struct array with fields .T (°C) and .RH (%)

    n = numel(channelList);
    results(n) = struct('T', [], 'RH', []);  % preallocate

    for k = 1:n
        idx = channelList(k);
        % select that sensor
        selectSensor(controller, idx);
        pause(0.01);  % wait for switch
        
        % read temperature and humidity
        [T, RH] = readSHT25(controller);
        results(k).T  = T;
        results(k).RH = RH;
    end

    % disable all channels when done
    closeAllPcaChannel(controller)
end
