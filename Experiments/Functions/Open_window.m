function [CFG] = Open_window(CFG)

CFG.general.screenid = max(Screen('Screens'));
[CFG.general.win, ~] = Screen('Openwindow', CFG.general.screenid, 0.5);
[~, CFG.general.theRect] = Screen('OpenOffscreenWindow', CFG.general.win, 0);
CFG.general.frame_rate = round(FrameRate());
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