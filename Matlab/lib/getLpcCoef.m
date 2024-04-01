% Wrapper for built-in LPC function with the option to add HIGH_FREQUENCY_REINTRODUCTION Heuristic
function lpc_coefs = getLpcCoef(audioIn, num_lpc, HIGH_FREQUENCY_REINTRODUCTION)
    % Add 1 to the num_lpc because the first LPC is always 1.0
    num_lpc = num_lpc + 1;
    if(HIGH_FREQUENCY_REINTRODUCTION)
        audioIn = diff(audioIn);
    end

    lpc_coefs = lpc(audioIn, num_lpc);
    lpc_coefs = lpc_coefs(2:num_lpc);
end

