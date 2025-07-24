function selectPcaChannel(controller, pcaAddr, channel)
% selectPcaChannel  Select a sub-channel on a PCA9548A I2C multiplexer
%   controller : Initialized ni845x controller object
%   pcaAddr    : 7-bit I2C address of the PCA9548A (decimal or from hex2dec('70','71'))
%   channel    : Integer 0–7 to select channel; -1 to disable all channels

    % Validate input
    if ~(isscalar(channel) && isnumeric(channel) && ((channel >= 0 && channel <= 7) || channel == -1))
        error('channel must be an integer 0–7, or -1 to disable all channels');
    end

    % Prepare control byte
    if channel == -1
        ctrlByte = uint8(0);
    else
        ctrlByte = bitshift(uint8(1), channel);
    end

    % Create I2C device object and write control byte
    pca = device(controller, I2CAddress=pcaAddr);
    write(pca, ctrlByte);
    clear pca;
end
