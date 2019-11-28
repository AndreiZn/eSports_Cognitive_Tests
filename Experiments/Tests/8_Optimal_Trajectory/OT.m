function [CFG, DATA] = OT(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

theRect = CFG_general.theRect;
centerX = CFG_general.centerXY(1,1);
centerY = CFG_general.centerXY(1,2);
win = CFG_general.win;
num_targets = CFG_test.num_targets;
length_cursor = CFG_test.length_cursor;
radius_circle = CFG_test.radius_circle;
% arrays to store x, y positions and velocities
objects_x = zeros(num_targets, 1); objects_y = zeros(num_targets, 1);

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

for trial_idx = 1:CFG_test.num_trials
    
    pos_mouse  = [];
    pos_target = [];
    pos_click  = [];
    reaction_time_click = [];
    %random distribution of circles
    NearToEachOther = 1;
    while NearToEachOther
        for i = 1:num_targets
            objects_x(i) = centerX + (rand - 0.5) * (theRect(RectRight) / 1.3);
            objects_y(i) = centerY + (rand - 0.5) * (theRect(RectBottom)/ 1.3);
        end
        
        NearToEachOther = 0;
        for i = 1:num_targets
            for j = i + 1:num_targets
                object_center_x_i = objects_x(i) + radius_circle / 2;
                object_center_y_i = objects_y(i) + radius_circle / 2;
                object_center_x_j = objects_x(j) + radius_circle / 2;
                object_center_y_j = objects_y(j) + radius_circle / 2;
                % break the loop if the circles don't overlap
                if ((object_center_x_i - object_center_x_j)^2 + (object_center_y_i - object_center_y_j)^2)^0.5 < radius_circle * 1.05
                    NearToEachOther = 1;
                end
            end
        end
    end
    
    % set mouse to center of the screen
    SetMouse(centerX, centerY, win);
    
    % Wait 0.5 seconds before the appearance of each circle
    t_temp = GetSecs;
    while GetSecs - t_temp < 0.5
        [x_mouse, y_mouse, buttons] = GetMouse(win);
        Screen('DrawLine',  win, CFG_general.white, x_mouse - length_cursor, y_mouse, x_mouse + length_cursor, y_mouse, 5);
        Screen('DrawLine',  win, CFG_general.white, x_mouse, y_mouse - length_cursor, x_mouse, y_mouse + length_cursor, 5);
        Screen('Flip',win);
    end
    
    % draw the circles
    for i = 1:num_targets
        Screen('FillOval', win, CFG_general.red, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
        Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
        pos_target = [pos_target; objects_x(i), objects_y(i)];
    end
     
    count_objects_clicked = 0;
    objects_click_label = zeros(num_targets, 1);
    time_start = GetSecs;
    time_stamp = [];
    [x_mouse, y_mouse, buttons] = GetMouse(win);
    while count_objects_clicked < num_targets 	% wait till enough circles are clicked
        [~, ~] = Apply_mouse_sensitivity(x_mouse, y_mouse, CFG);
        [x_mouse, y_mouse, buttons] = GetMouse(win);
        
        pos_mouse  = [pos_mouse; x_mouse y_mouse];
        time_stamp = [time_stamp; GetSecs - time_start];
        
        if buttons(1)
            for i = 1:num_targets
                object_center_x = objects_x(i) + radius_circle / 2;
                object_center_y = objects_y(i) + radius_circle / 2;
                if ((x_mouse - object_center_x)^2 + (y_mouse - object_center_y)^2)^0.5 < (radius_circle * 0.5) % decide which circles is clicked
                    if objects_click_label(i) == 0
                        objects_click_label(i) = 1;
                        count_objects_clicked = count_objects_clicked + 1;
                        pos_click = [pos_click; object_center_x, object_center_y];
                        reaction_time_click = [reaction_time_click; GetSecs - time_start];
                    end
                end
            end
        end
        
        % update color
        for i = 1:num_targets
            if objects_click_label(i) == 0
                Screen('FillOval', win, CFG_general.red, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
                Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
            else
                Screen('FillOval', win, CFG_general.blue, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
                Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
            end
        end
        
        Screen('DrawLine',  win, CFG_general.white, x_mouse - length_cursor, y_mouse, x_mouse + length_cursor, y_mouse, 5);
        Screen('DrawLine',  win, CFG_general.white, x_mouse, y_mouse - length_cursor, x_mouse, y_mouse + length_cursor, 5);
        Screen('Flip', win);

        
        Close_screen_if_escKey_pressed(CFG_general.escKey)
    end
    time_end = GetSecs;
    time_reaction = time_end - time_start;
    
    length_traj = 0;
    for i = 2:size(pos_mouse, 1)
        distance = ((pos_mouse(i, 1) - pos_mouse(i - 1, 1))^2 + (pos_mouse(i, 2) - pos_mouse(i - 1, 2))^2)^0.5;
        length_traj = length_traj + distance;
    end
    
    DATA_test.length_traj(trial_idx, 1) = length_traj;
    DATA_test.time_reaction(trial_idx, 1) = time_reaction;
    DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
    DATA_test.mouse_trajectory{trial_idx, 1} = pos_mouse;
    DATA_test.target_pos{trial_idx, 1} = pos_target;
    DATA_test.time_stamp{trial_idx, 1} = time_stamp;
    DATA_test.pos_click{trial_idx, 1} = pos_click;
    DATA_test.reaction_time_click{trial_idx, 1} = reaction_time_click;
    
    WaitSecs(1);
end

DATA_test.radius_circle = radius_circle;
DATA_test.num_trials = CFG_test.num_trials;
DATA.tests{test_idx} = DATA_test;

WaitSecs(0.3)