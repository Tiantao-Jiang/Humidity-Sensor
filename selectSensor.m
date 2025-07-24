function selectSensor(controller, sensorIdx)
% selectSensor  Select one of 15 sensors (0–14) using two cascaded PCA9548A I2C multiplexers
%   controller : Initialized ni845x controller object
%   sensorIdx  : Index of the sensor (0–14)

    % Validate sensor index
    if sensorIdx < 0 || sensorIdx > 14
        error('sensorIdx must be between 0 and 14');
    end

    % Address of the first-level multiplexer
    ADDR1 = hex2dec('70');
    % Address of the second-level multiplexer
    ADDR2 = hex2dec('71');

    if sensorIdx < 7
        % Select channel (sensorIdx+1) on the first-level mux, disable second-level
        selectPcaChannel(controller, ADDR1, sensorIdx + 1);
    else
        % To access the second-level mux:
        %   1) Enable channel 0 on the first-level mux
        %   2) Select channel (sensorIdx-7) on the second-level mux
        selectPcaChannel(controller, ADDR1, 0);
        selectPcaChannel(controller, ADDR2, sensorIdx - 7);
    end
end