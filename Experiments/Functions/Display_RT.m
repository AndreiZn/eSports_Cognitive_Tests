% function uses Screen('DrawText', ...) function to display subject's reaction time
function Display_RT(CFG_general, best_rt, average_rt, last_rt)

best_rt = num2str(round(best_rt));
average_rt = num2str(round(average_rt));
last_rt = num2str(round(last_rt));
best_rt_line = ['Best reaction time: ', best_rt, ' ms'];
average_rt_line = ['Average reaction time: ', average_rt, ' ms'];
last_rt_line = ['Last reaction time: ', last_rt, ' ms'];

Screen('DrawText', CFG_general.win, best_rt_line, ...
    CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), 0.05*CFG_general.theRect(4), ...
    CFG_general.textcolor);
Screen('DrawText', CFG_general.win, average_rt_line, ...
    CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), 0.1*CFG_general.theRect(4), ...
    CFG_general.textcolor);
Screen('DrawText', CFG_general.win, last_rt_line, ...
    CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), 0.15*CFG_general.theRect(4), ...
    CFG_general.textcolor);


