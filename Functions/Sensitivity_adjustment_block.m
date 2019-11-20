function [x_mouse, y_mouse, CFG, out] = Sensitivity_adjustment_block(x_mouse, y_mouse, CFG) 

win = CFG.general.win;
theRect = CFG.general.theRect;
CSGO_coef = CFG.general.CSGO_coef;

out = 0;
Display_text(CFG.general, {'Adjust sensitivity by pressing Left/Right arrows on your keyboard.', 'Press spacebar when you''re comfortable with mouse sensitivity.'});

[~, ~, keyCode] = KbCheck;
if keyCode(CFG.general.RightArrowKey)
    WaitSecs(0.15)
    CFG.general.sensitivity_skip_factor = CFG.general.sensitivity_skip_factor + 0.05*CSGO_coef;
elseif keyCode(CFG.general.LeftArrowKey)
    WaitSecs(0.15)
    CFG.general.sensitivity_skip_factor = CFG.general.sensitivity_skip_factor - 0.05*CSGO_coef;
elseif keyCode(CFG.general.spaceKey)
    out = 1;
end

display_sens_text = ['Sensitivity: ', num2str(round(CFG.general.sensitivity_skip_factor/CSGO_coef, 2))];
Screen('DrawText', win, display_sens_text, 0.6*theRect(3), 0.01*theRect(4), [200 0 0]);

[x_mouse, y_mouse] = Apply_mouse_sensitivity(x_mouse, y_mouse, CFG);
