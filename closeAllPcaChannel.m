function closeAllPcaChannel(controller)
    
    % colse all channels
    selectPcaChannel(controller, hex2dec('70'), 0);
    selectPcaChannel(controller, hex2dec('71'), -1);
    selectPcaChannel(controller, hex2dec('70'), -1);