function [CFG] = Open_window(CFG, subject_screen_flag)
% With new corrections, Sergei
if nargin < 2
    subject_screen_flag = 0;
end

screens_list = Screen('Screens'); % New corrections started, Sergei
% if there is only one screen, that subject_screen_flag should be 0
if length(screens_list) < 2
    subject_screen_flag = 0;
end

CFG.general.screenid = screens_list(end - subject_screen_flag); % New corrections ended, Sergei

[CFG.general.win, ~] = Screen('Openwindow', CFG.general.screenid, 0.5);

[~, CFG.general.theRect] = Screen('OpenOffscreenWindow', CFG.general.win, 0);
CFG.general.frame_rate = round(FrameRate(CFG.general.screenid));
CFG.general.ratio_pixel = CFG.general.theRect(RectBottom) / CFG.general.default_resolution(2);
CFG.general.ratio_frame_rate = CFG.general.frame_rate / CFG.general.default_frame_rate;
CFG.general.font_size = 24 * CFG.general.ratio_pixel;

% get center (x and y position) of the screen
CFG.general.centerXY = [CFG.general.theRect(RectRight)/2 CFG.general.theRect(RectBottom)/2];
SetMouse(CFG.general.centerXY(1,1), CFG.general.centerXY(1,2), CFG.general.win);

% fill color to screen, display some texts
Screen('FillRect', CFG.general.win, CFG.general.bgcolor);
Screen('TextSize', CFG.general.win, CFG.general.font_size);
display_text = {'Инициализация'; 'Initializing...'};
Display_text(CFG.general, display_text(CFG.general.language));
WaitSecs(1);