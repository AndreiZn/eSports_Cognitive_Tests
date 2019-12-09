% function uses Screen('DrawText', ...) function to display subject's keys
% per minute rate
function Display_KPM(CFG_general, average_kpm, num_mistakes)

average_kpm = num2str(round(average_kpm));
average_kpm_line = ['Average keys per minute: ', average_kpm];
num_mistakes = num2str(round(num_mistakes));
num_mistakes_line = ['Number of mistakes: ', num_mistakes];

Screen('DrawText', CFG_general.win, num_mistakes_line, ...
    CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), 0.05*CFG_general.theRect(4), ...
    CFG_general.textcolor);

Screen('DrawText', CFG_general.win, average_kpm_line, ...
    CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), 0.1*CFG_general.theRect(4), ...
    CFG_general.textcolor);
