%% Main script to initialize controller, scan sensors, and measure temperature/humidity
clear; clc;

% Create and initialize the NI‑845x I2C controller
ctrl = ni845x("01C3606E");

% Initialize the cascaded PCA9548A multiplexers on the I2C bus
initMultiplexers(ctrl);

% Scan all multiplexer channels for connected SHT25 sensors
ch = findSHT25Channels(ctrl);

% Display list of available (responsive) channels
disp("Available SHT25 channels:");
disp(ch);

% Measure temperature and humidity on each detected channel
result = measureSHT25OnChannels(ctrl, ch);

% Display measurement results as a table or array [channel, temp, humidity]
disp("Measurement results (channel, T (°C), RH (%)):");
disp(result);
