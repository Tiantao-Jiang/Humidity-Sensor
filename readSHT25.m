function [T_degC, RH_percent] = readSHT25(controller)
% readSHT25   Read temperature and humidity from an SHT25 sensor on the I2C bus
%   controller    : Initialized ni845x controller object
%   returns:
%     T_degC       : Temperature in degrees Celsius
%     RH_percent   : Relative humidity in percent

    % Default 7-bit I2C address for SHT25
    SHT_ADDR = hex2dec('40');

    % Create I2C device object for the sensor
    sht = device(controller, I2CAddress=SHT_ADDR);

    % --- Temperature Measurement ---
    % Trigger temperature measurement (No Hold Master mode: command 0xF3)
    write(sht, uint8(0xF3));
    pause(0.085);  % Wait up to 85 ms for measurement to complete

    % Read 3 bytes: MSB, LSB, CRC
    data = read(sht, 3);
    T_raw = bitshift(uint16(data(1)), 8) + uint16(data(2));
    % Conversion formula from the datasheet:
    %   T (°C) = -46.85 + 175.72 * T_raw / 2^16
    T_degC = -46.85 + 175.72 * double(T_raw) / 65536;

    % --- Humidity Measurement ---
    % Trigger humidity measurement (No Hold Master mode: command 0xF5)
    write(sht, uint8(0xF5));
    pause(0.029);  % Wait up to 29 ms for measurement to complete

    % Read 3 bytes: MSB, LSB, CRC
    data = read(sht, 3);
    H_raw = bitshift(uint16(data(1)), 8) + uint16(data(2));
    % Conversion formula from the datasheet:
    %   RH (%) = -6 + 125 * H_raw / 2^16
    RH_percent = -6 + 125 * double(H_raw) / 65536;

    % Clean up device object
    clear sht;
end