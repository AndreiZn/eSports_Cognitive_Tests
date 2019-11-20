function [CFG, DATA] = AIM(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

theRect = CFG_general.theRect;
centerX = CFG_general.centerXY(1,1);
centerY = CFG_general.centerXY(1,2);
win = CFG_general.win;
radius_target = CFG_test.radius_target;
length_cursor = CFG_test.length_cursor;
array_pixel_distance = [];
array_time_length_ratio = [];

% Adjust sensitivity
ShowCursor;
[x_mouse,y_mouse,~] = GetMouse(win);
while 1
    
    [x_mouse, y_mouse, CFG, out] = Sensitivity_adjustment_block(x_mouse, y_mouse, CFG);
    if out
        break
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start experiment
% Show instructions and wait for mouse click/keyboard tap
Display_text(CFG_general, CFG_test.test_instructions(CFG_general.language, :));

% wait for a click
[~, ~, ~, buttons] = GetClicks([],0,[]);
% wait for button release
while buttons(1)
    [~, ~, buttons] = GetMouse;
    WaitSecs('YieldSecs', 0.01);
end

HideCursor;

% set mouse to center of the screen
SetMouse(centerX, centerY, win);

[x_mouse, y_mouse] = GetMouse(win);
x_target = centerX + (rand - 0.5) * (theRect(RectRight) / 1.2);
y_target = centerY + (rand - 0.5) * (theRect(RectBottom)/ 1.2);

% while 1
%     Screen('FillOval',  win, CFG_general.red, frame_target_outer);
%     Screen('FrameOval', win, CFG_general.black, frame_target_outer, 5);
%     Screen('DrawLine',  win, CFG_general.white, x_mouse - length_cursor, y_mouse, x_mouse + length_cursor, y_mouse, 5);
%     Screen('DrawLine',  win, CFG_general.white, x_mouse, y_mouse - length_cursor, x_mouse, y_mouse + length_cursor, 5);
% %     [x_mouse, y_mouse, sensitivity_skip_factor, out] = sensitivity_adjustment_block(win, RightArrowKey, LeftArrowKey, spaceKey, theRect, centerXY, x_mouse, y_mouse, font_size, textcolor, sensitivity_skip_factor, CSGO_coef) ;
% %     if out
% %         break
% %     end
% end

for trial_idx = 1:CFG_test.num_trials
    flag_button_clicked = 0;
    SetMouse(centerX, centerY, win);
    [x_mouse, y_mouse, buttons] = GetMouse(win);
    Screen('DrawLine',  win, CFG_general.white, x_mouse - length_cursor, y_mouse, x_mouse + length_cursor, y_mouse, 5);
    Screen('DrawLine',  win, CFG_general.white, x_mouse, y_mouse - length_cursor, x_mouse, y_mouse + length_cursor, 5);
    Screen('Flip',win);
    WaitSecs(0.5);
    
    % generate circles at random pos
    x_target = centerX + (rand - 0.5) * (theRect(RectRight) / 1.2);
    y_target = centerY + (rand - 0.5) * (theRect(RectBottom)/ 1.2);
    pos_target = [x_target y_target];
    
    [x, y, buttons] = GetMouse(win);
    pos_mouse = [x y];
    
    time_start = GetSecs;
    time_stamp = now;
    [x_mouse, y_mouse, buttons] = GetMouse(win);
    while GetSecs < (time_start + CFG_test.time_timeout)
        frame_target_outer = [x_target - radius_target / 2, y_target - radius_target / 2, x_target + radius_target / 2, y_target + radius_target / 2];
        frame_target_inner = [x_target - radius_target / 4, y_target - radius_target / 4, x_target + radius_target / 4, y_target + radius_target / 4];
        
        Screen('FillOval', win, CFG_general.red, frame_target_outer);
        Screen('FrameOval', win, CFG_general.black, frame_target_outer, 5);
        
        [~, ~] = Apply_mouse_sensitivity(x_mouse, y_mouse, CFG);
        [x_mouse, y_mouse, buttons] = GetMouse(win);

        Screen('DrawLine', win, CFG_general.white, x_mouse - length_cursor, y_mouse, x_mouse + length_cursor, y_mouse, 5);
        Screen('DrawLine', win, CFG_general.white, x_mouse, y_mouse - length_cursor, x_mouse, y_mouse + length_cursor, 5);
        
        Screen('Flip',win);
        
        %pos_target = [pos_target; x_target y_target];
        pos_mouse  = [pos_mouse; x_mouse y_mouse];
        time_stamp = [time_stamp; now];
        
        % if left click captured
        if buttons(1)
            pixel_distance = (abs(x_target - x_mouse)^2 + abs(y_target - y_mouse)^2)^0.5;
            if pixel_distance < (radius_target / 2)
                x_click = x_mouse;
                y_click = y_mouse;
                
                time_end = GetSecs;
                time_reaction = time_end - time_start;
                flag_button_clicked = 1;
                break;
            end
        end
        
        Close_screen_if_escKey_pressed(CFG_general.escKey)
        
        WaitSecs(1 / CFG_general.frame_rate);

    end
    
    if ~flag_button_clicked
        time_reaction = CFG_test.time_timeout;
    end
    
    pixel_distance = (abs(x_target - x_click)^2 + abs(y_target - y_click)^2)^0.5;
    
    traj_unique = [pos_mouse(1,:)];
    for i = 2:size(pos_mouse, 1)
        if (abs(pos_mouse(i,1) - pos_mouse(i - 1,1))^2 + abs(pos_mouse(i, 2) - pos_mouse(i -1, 2))^2)^0.5 > 1
            traj_unique = [traj_unique; pos_mouse(i,:)];
        end
    end

    time_length_ratio = size(traj_unique, 1) / time_reaction * 1000;
    
    array_pixel_distance = [array_pixel_distance; pixel_distance];
    array_time_length_ratio = [array_time_length_ratio; time_length_ratio];
    
    DATA_test.pixel_distance(trial_idx, 1) = pixel_distance;
    DATA_test.time_reaction(trial_idx, 1) = time_reaction;
    DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
    DATA_test.mouse_trajectory{trial_idx, 1} = pos_mouse;
    DATA_test.target_pos(trial_idx, :) = pos_target;
    DATA_test.time_stamp{trial_idx, 1} = time_stamp;

    WaitSecs(1);
end


DATA_test.num_trials = CFG_test.num_trials;
DATA.tests{test_idx} = DATA_test;

WaitSecs(0.3)