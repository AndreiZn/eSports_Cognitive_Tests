function [CFG, DATA] = MT(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

theRect = CFG_general.theRect;
centerX = CFG_general.centerXY(1,1);
centerY = CFG_general.centerXY(1,2);
win = CFG_general.win;
cursor_length = CFG_test.cursor_length;
target_radius = CFG_test.target_radius;
screenid = CFG_general.screenid;% New corrections, Sergei

% Adjust sensitivity
ShowCursor;

SetMouse(centerX, centerY, screenid);% New corrections, Sergei

[x_mouse,y_mouse,~] = GetMouse(screenid);
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

[~, ~] = Wait_user_input(CFG_general, CFG_test);

HideCursor;

for trial_idx = 1:CFG_test.num_trials
    for i = 3:-1:1
        display_text = {['Current Trial Number: ' num2str(trial_idx) '  Total Trial Number: ' num2str(CFG_test.num_trials)], ...
                        ['Track the target. Trial starts in ' num2str(i) ' seconds.']};
        Display_text(CFG_general, display_text);
        WaitSecs(1);
    end
    
    disp(['6: ' num2str(CFG.general.win)]);
    disp(CFG_general.win);
    
    SetMouse(centerX, centerY, screenid);% New corrections, Sergei
    
    x_target = centerX; y_target = centerY;
    pos_target = [x_target y_target];
    
    v_target_x = (rand - 0.5) * 2 * CFG_test.speed_coef_x;
    v_target_y = (rand - 0.5) * 2 * CFG_test.speed_coef_y;
    
    [x, y, buttons] = GetMouse(screenid);% New corrections, Sergei
    pos_mouse = [x y];
    
    timeStart = GetSecs;
    timeLim = timeStart;
    time_stamp = now;
    [x_mouse, y_mouse, ~] = GetMouse(screenid);% New corrections, Sergei
    while GetSecs < (timeStart + CFG_test.experiment_time)
        if (GetSecs - timeLim) > CFG_test.time_step_target_changes_speed
            timeLim = GetSecs;
            v_target_x = (rand - 0.5) * 2 * CFG_test.speed_coef_x;
            v_target_y = (rand - 0.5) * 2 * CFG_test.speed_coef_y;
        end
        
        x_target = x_target + v_target_x;
        y_target = y_target + v_target_y;
        
        if x_target < (theRect(RectLeft) + target_radius / 2) || x_target > (theRect(RectRight) - target_radius / 2)
            v_target_x = -v_target_x;
            x_target   = x_target + 2 * v_target_x;
        end
        
        if y_target < (theRect(RectTop) + target_radius / 2) || y_target > (theRect(RectBottom) - target_radius / 2)
            v_target_y = -v_target_y;
            y_target   = y_target + 2 * v_target_y;
        end
        
        frame_target_outer = [x_target - target_radius / 2, y_target - target_radius / 2, x_target + target_radius / 2, y_target + target_radius / 2];
        frame_target_inner = [x_target - target_radius / 4, y_target - target_radius / 4, x_target + target_radius / 4, y_target + target_radius / 4];
        
        Screen('FillOval',  win, CFG_general.red, frame_target_outer);
        Screen('FrameOval', win, CFG_general.black, frame_target_outer, 5);
        Screen('FillOval',  win, CFG_general.black, frame_target_inner);
        Screen('FrameOval', win, CFG_general.black, frame_target_inner, 5);
        Screen('DrawLine',  win, CFG_general.white, x_target - cursor_length, y_target, x_target + cursor_length, y_target, 5);
        Screen('DrawLine',  win, CFG_general.white, x_target, y_target - cursor_length, x_target, y_target + cursor_length, 5);
        
        
        [~, ~] = Apply_mouse_sensitivity(x_mouse, y_mouse, CFG);
        [x_mouse, y_mouse, buttons] = GetMouse(screenid);% New corrections, Sergei
        Screen('DrawLine',  win, CFG_general.white, x_mouse - cursor_length, y_mouse, x_mouse + cursor_length, y_mouse, 5);
        Screen('DrawLine',  win, CFG_general.white, x_mouse, y_mouse - cursor_length, x_mouse, y_mouse + cursor_length, 5);
        Screen('Flip',win);
        
        pos_target = [pos_target; x_target y_target];
        pos_mouse = [pos_mouse; x_mouse y_mouse];
        time_stamp = [time_stamp; now];
        
        Close_screen_if_escKey_pressed(CFG_general.escKey)
        
        WaitSecs(1 / CFG_general.frame_rate);
    end
    
    pixel_distance = abs(pos_target - pos_mouse);
    pixel_distance = (pixel_distance(:, 1) .^ 2 + pixel_distance(: , 2) .^ 2) .^ 0.5;
    tracking_error = mean(pixel_distance);
    error_std = std(pixel_distance);
    
    DATA_test.tracking_error(trial_idx, 1) = tracking_error;
    DATA_test.error_std(trial_idx, 1) = error_std;
    DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
    DATA_test.mouse_trajectory{trial_idx, 1} = pos_mouse;
    DATA_test.target_pos{trial_idx, 1} = pos_target;
    DATA_test.time_stamp{trial_idx, 1} = time_stamp;
    
end

DATA_test.num_trials = CFG_test.num_trials;
DATA.tests{test_idx} = DATA_test;

Screen('FillRect', CFG_general.win, CFG_general.bgcolor);
results = [mean(DATA_test.tracking_error(:, 1))];
results_description = {'Average error: '};
results_dimension = {'pix'};
position = 'center';
Display_Results(CFG_general, results, results_description, results_dimension, position)
Screen('Flip', CFG_general.win);
WaitSecs(10)