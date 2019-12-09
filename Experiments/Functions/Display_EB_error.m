% function uses Screen('DrawText', ...) function to display subject's error
% in the Expanding Ball test
function Display_EB_error(CFG_general, best_error, average_error, last_error)

best_error = num2str(round(best_error));
average_error = num2str(round(average_error));
last_error = num2str(round(last_error));
best_error_line = ['Best error, pix: ', best_error, ' ms'];
average_error_line = ['Average error, pix: ', average_error, ' ms'];
last_error_line = ['Last error, pix: ', last_error, ' ms'];

Screen('DrawText', CFG_general.win, best_error_line, ...
    CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), 0.05*CFG_general.theRect(4), ...
    CFG_general.textcolor);
Screen('DrawText', CFG_general.win, average_error_line, ...
    CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), 0.1*CFG_general.theRect(4), ...
    CFG_general.textcolor);
Screen('DrawText', CFG_general.win, last_error_line, ...
    CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), 0.15*CFG_general.theRect(4), ...
    CFG_general.textcolor);


