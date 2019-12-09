% 1. Target constant, speed constant
% 2. Target constant, speed not constant
% 3. Target not constant, speed not constant
% 4. Target beats, speed not constant
function [CFG, DATA] = EB_Core(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

centerXY = CFG_general.centerXY;
centerX = centerXY(1,1);
centerY = centerXY(1,2);
win = CFG_general.win;
bgcolor = CFG_general.bgcolor;
textcolor = CFG_general.textcolor;

target_const = CFG_test.target_const;
circle_speed_const = CFG_test.circle_speed_const;
target_moves = CFG_test.target_moves;
target_moving_speed = CFG_test.target_moving_speed;
time_target_move_one_direction = CFG_test.time_target_move_one_direction;
num_trials = CFG_test.num_trials;
time_max = CFG_test.time_max;
time_redraw = CFG_test.time_redraw;
rtwait = CFG_test.rtwait;
cursor_length = CFG_test.cursor_length;
color = CFG_test.circle_color;
target_color = CFG_test.target_color;
best_error = 0;
average_error = 0;
last_error = 0;

x_expand = centerX;
y_expand = centerY;
x_target  = centerX;
y_target  = centerY;
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

stop_experiment = 0;
trial_idx = 0; % counter of trials performed
array_error = [];

last_change_in_direction = GetSecs; % change in expansion or shrinking;
flag_expand_direction = 0;

while ~stop_experiment
    
    radius_target = CFG_test.radius_target;
    expand_speed = CFG_test.expand_speed;
    
    if ~circle_speed_const
        r_coef = 0.5 + rand(); % 1 on average
        expand_speed = expand_speed * r_coef;
    end
    
    if ~target_const
        r_coef = 0.5 + rand(); 
        radius_target = radius_target * r_coef;
    end
    
    radius_current_expand = 0;
    time_out = 0;
    delta_time = 0;
    
    % wait for button release
    [x, y, buttons] = GetMouse;
    while buttons(1)
        [x,y,buttons] = GetMouse;
        WaitSecs('YieldSecs', rtwait);
    end
    
    txt = sprintf('\n%d / %d\n  \n % %d', [trial_idx + 1, num_trials, 1]);
    txt_time = sprintf('\n %4.2f sec out of %4.2f\n',[delta_time, time_max]);
    Screen('DrawText', win, txt_time, centerXY(1) + 350, centerXY(2)-350,textcolor);
    
    start_time = GetSecs;
    while 1
        
        if target_moves
            if GetSecs - last_change_in_direction > time_target_move_one_direction
                last_change_in_direction = GetSecs;
                flag_expand_direction = ~flag_expand_direction;
            end
            
            if flag_expand_direction
                radius_target = radius_target + target_moving_speed;
            else
                radius_target = radius_target - target_moving_speed;
            end
        end
        
        radius_current_expand = floor(radius_current_expand + expand_speed);
        
        time_current = GetSecs;
        delta_time = time_current - start_time;
        txt_time = sprintf('\n %4.2f sec out of %4.2f\n',[delta_time,time_max]);
        
        Screen('DrawText',win,txt , centerXY(1) + 550,centerXY(2),textcolor);
        Screen('FillOval',  win, color, [x_expand - radius_current_expand / 2, y_expand - radius_current_expand / 2, x_expand + radius_current_expand / 2, y_expand + radius_current_expand / 2]);
        Screen('FrameOval', win, target_color, [x_expand - radius_target / 2, y_expand - radius_target / 2, x_expand + radius_target / 2, y_expand + radius_target / 2], 5);
        Screen('DrawLine',  win, target_color, x_target - cursor_length, y_target, x_target + cursor_length, y_target, 5);
        Screen('DrawLine',  win, target_color, x_target, y_target - cursor_length, x_target, y_target + cursor_length, 5);
        Screen('DrawText',win,txt_time , centerXY(1) + 350,centerXY(2)-350,textcolor);
        Display_EB_error(CFG_general, best_error, average_error, last_error)
        Screen('Flip',win);
        
        time_out = delta_time > time_max;
        [x, y, buttons] = GetMouse;
        
        if buttons(1) || time_out
            break
        end
        
        Close_screen_if_escKey_pressed(CFG_general.escKey)
        
        WaitSecs(time_redraw); % put in small interval to allow other system events
    end
    
    while buttons(1) % wait for release
        [x, y, buttons] = GetMouse;
        WaitSecs('YieldSecs', rtwait);
    end
    
    trial_idx = trial_idx + 1;
    error_radius  = radius_target - radius_current_expand;
    array_error = [array_error; error_radius];
    
    DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
    DATA_test.error_radius(trial_idx, 1) = error_radius;
    DATA_test.delta_time(trial_idx, 1) = delta_time;
    DATA_test.radius_target(trial_idx, 1) = radius_target;
    DATA_test.expand_speed(trial_idx, 1) = expand_speed;
    DATA_test.target_moving_speed(trial_idx, 1) = target_moving_speed;
    
    best_error_idx = dsearchn(DATA_test.error_radius(1:trial_idx, 1), 0);
    best_error = DATA_test.error_radius(best_error_idx, 1);
    average_error = mean(DATA_test.error_radius(1:trial_idx, 1));
    last_error = DATA_test.error_radius(trial_idx, 1);
    Display_EB_error(CFG_general, best_error, average_error, last_error)
    Screen('Flip', CFG_general.win);
    
    % determine whether the trial is completed
    if trial_idx < num_trials
        for i = 2:-1:1
            Screen('FillRect', win, bgcolor);       
            Screen('DrawText',win,['Next trial begins after ' num2str(i) ' seconds.'] , centerXY(1) - 100,centerXY(2) - 40,textcolor);
            Display_EB_error(CFG_general, best_error, average_error, last_error)
            Screen('Flip',win);
            WaitSecs(1);
        end
    else
        stop_experiment = 1;
    end
end

DATA.tests{test_idx} = DATA_test;

WaitSecs(0.3)