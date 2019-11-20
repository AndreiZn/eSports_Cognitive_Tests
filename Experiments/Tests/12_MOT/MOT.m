function [CFG, DATA] = MOT(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

theRect = CFG_general.theRect;
centerXY = CFG_general.centerXY;
centerX = centerXY(1,1);
centerY = centerXY(1,2);
win = CFG_general.win;
bgcolor = CFG_general.bgcolor;
textcolor = CFG_general.textcolor;
font_size = CFG_general.font_size;

num_min_target = CFG_test.num_min_target;
num_max_target = CFG_test.num_max_target;
num_trials_per_level = CFG_test.num_trials_per_level;
speed_coef_x = CFG_test.speed_coef_x;
speed_coef_y = CFG_test.speed_coef_y;
num_total_trials = CFG_test.num_total_trials;
radius_circle = CFG_test.radius_circle;
target_color = CFG_test.target_color;
circle_color = CFG_test.circle_color;
correct_circle_color = CFG_test.correct_circle_color;

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

num_trial_performed = zeros(num_max_target - num_min_target + 1, 1);    % array to store numbers of trials performed so far
stop_experiment = 0;        % flag to stop the experiment
trial_idx = 0; % counter of trials performed
while ~stop_experiment
    
    Close_screen_if_escKey_pressed(CFG_general.escKey)
    
    all_circles_final_pos = [];
    final_pos = [];
    click_pos = [];
    
    % generate number of targets for next trial
    r = num_min_target;
    while 1
        if num_trial_performed(r - num_min_target + 1, 1) < num_trials_per_level
            num_trial_performed(r - num_min_target + 1, 1) = num_trial_performed(r - num_min_target + 1, 1) + 1;
            num_target = r;
            num_object = num_target * 2; % number of circles = number of targets * 2
            break;
        else
            r = r + 1;
        end
    end
    
    trial_idx = trial_idx + 1;
    %   Experimental instructions, start experiment aftre countdown
    for i = 3:-1:1
        Screen('FillRect', win, bgcolor);
        Screen('TextSize', win, font_size);
        
        display_text = ['Trial starts in ' num2str(i) ' seconds.'];
        Screen('DrawText',win, display_text, centerXY(1) - floor(length(display_text) * font_size / 4),centerXY(2) - 40,textcolor);
        
        display_text = ['Current Trial Number: ' num2str(trial_idx) '  Total Trial Number: ' num2str(num_total_trials)];
        Screen('DrawText',win, display_text, centerXY(1) - floor(length(display_text) * font_size / 4), centerXY(2) + 40,textcolor);
        
        Screen('Flip',win);
        WaitSecs(1);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Start Experiment, show the circles
    flag_display_target = true;
    HideCursor;
    % array to store x, y positions and velocities
    objects_x   = zeros(num_object, 1); objects_y   = zeros(num_object, 1);
    objects_v_x = zeros(num_object, 1); objects_v_y = zeros(num_object, 1);
    objects_target_label = zeros(num_object, 1); % label to identify whether the circles are selected as target
    for i = 1:num_target
        objects_target_label(i) = 1; % mark half the circles as target. num_target = num_circle / 2
    end
    
    %random distribution of circles
    NearToEachOther = 1;
    while NearToEachOther
        for i = 1:num_object
            objects_x(i) = centerX + (rand - 0.5) * (theRect(RectRight) / 1.5);
            objects_y(i) = centerY + (rand - 0.5) * (theRect(RectBottom)/ 1.5);
            objects_v_x(i) = (rand - 0.5) * 2; % velocity -1 ~ 1
            objects_v_y(i) = (rand - 0.5) * 2;
        end
        
        NearToEachOther = 0;
        for i = 1:num_object
            for j = i + 1:num_object
                object_center_x_i = objects_x(i) + radius_circle /2;
                object_center_y_i = objects_y(i) + radius_circle /2;
                object_center_x_j = objects_x(j) + radius_circle /2;
                object_center_y_j = objects_y(j) + radius_circle /2;
                % break the loop if the circles don't overlap
                if ((object_center_x_i - object_center_x_j)^2 + (object_center_y_i - object_center_y_j)^2)^0.5 < radius_circle * 1.05
                    NearToEachOther = 1;
                end
            end
        end
    end
    
    % draw the circles
    for i = 1:num_object
        Screen('FillOval', win, circle_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
        Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
    end
    Screen('Flip',win);
    WaitSecs(2);
    
    % flash targets
    for j = 1:9
        for i = 1:num_object
            if i <= num_target
                if flag_display_target
                    Screen('FillOval', win, target_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
                    Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
                end
            else
                Screen('FillOval', win, circle_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
                Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
            end
        end
        
        Screen('Flip', win);
        WaitSecs(0.2);
        flag_display_target = ~flag_display_target;
    end
    WaitSecs(1);
    
    % circles start moving
    timeStart = GetSecs;	% get current time
    NearToEachOther = 0;
    while GetSecs < (timeStart + CFG_test.time_experiment) || NearToEachOther
        for i = 1:num_object
            % refresh x, y positions of circles
            objects_x(i) = objects_x(i) + objects_v_x(i) * speed_coef_x;
            objects_y(i) = objects_y(i) + objects_v_y(i) * speed_coef_y;
            
            % bounce back if the circles touch the edge of screen
            if objects_x(i) < (theRect(RectLeft) + 0) || objects_x(i) > (theRect(RectRight) - radius_circle)
                objects_v_x(i) = -objects_v_x(i);
                objects_x(i) = objects_x(i) + 2 * objects_v_x(i);
            end
            
            if objects_y(i) < (theRect(RectTop) + 0) || objects_y(i) > (theRect(RectBottom) - radius_circle)
                objects_v_y(i) = -objects_v_y(i);
                objects_y(i) = objects_y(i) + 2 * objects_v_y(i);
            end
            
            % draw circle
            Screen('FillOval', win, circle_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
            Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
        end
        
        % check whether the circles overlap
        NearToEachOther = 0;
        for i = 1:num_object
            for j = i + 1:num_object
                object_center_x_i = objects_x(i) + radius_circle / 2;
                object_center_y_i = objects_y(i) + radius_circle / 2;
                object_center_x_j = objects_x(j) + radius_circle / 2;
                object_center_y_j = objects_y(j) + radius_circle / 2;
                if ((object_center_x_i - object_center_x_j)^2 + (object_center_y_i - object_center_y_j)^2)^0.5 < radius_circle * 1.05
                    NearToEachOther = 1;
                end
            end
        end
        Screen('Flip', win);
        
        Close_screen_if_escKey_pressed(CFG_general.escKey)
    end
    
    %stop circles so as to be clicked
    for i = 1:num_object
        all_circles_final_pos = [all_circles_final_pos; objects_x(i) + radius_circle / 2 objects_y(i) + radius_circle / 2];
        Screen('FillOval', win, circle_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
        Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
    end
    Screen('Flip',win);
    
    ShowCursor;
    count_objects_clicked = 0;
    objects_click_label = zeros(num_object,1);
    while count_objects_clicked < num_target 	% wait till enough circles are clicked
        [clicks, x, y, whichButton] = GetClicks([],0,[]);
        for i = 1:num_object
            object_center_x = objects_x(i) + radius_circle / 2;
            object_center_y = objects_y(i) + radius_circle / 2;
            if (((x - object_center_x)^2 + (y - object_center_y)^2)^0.5) < (radius_circle * 0.5) % decise which circles is clicked
                if objects_click_label(i) == 0
                    objects_click_label(i) = 1;
                    count_objects_clicked = count_objects_clicked + 1;
                    
                    click_pos = [click_pos; object_center_x object_center_y]; % save the positions of the objects clicked
                    break;
                end
            end
        end
        
        for i = 1:num_object
            if objects_click_label(i) ~= 1
                Screen('FillOval', win, circle_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
                Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
            else
                Screen('FillOval', win, correct_circle_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
                Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
            end
        end
        Screen('Flip',win);
        Close_screen_if_escKey_pressed(CFG_general.escKey)
    end
    
    count_correct = 0;
    for i = 1:num_target
        if objects_click_label(i) == 1
            count_correct = count_correct + 1;
        end
    end
    accuracy = count_correct / num_target;
    
    %Show the correct answer
    for i = 1:num_object
        if i <= num_target
            Screen('FillOval', win, target_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
            Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
            final_pos = [final_pos; objects_x(i) + radius_circle / 2 objects_y(i) + radius_circle / 2]; % save the positions of the targets
        else
            Screen('FillOval', win, circle_color, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle]);
            Screen('FrameOval', win, CFG_general.black, [objects_x(i), objects_y(i), objects_x(i) + radius_circle, objects_y(i) + radius_circle], 5);
        end
    end
    Screen('Flip', win);
    WaitSecs(1);
    
    DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
    DATA_test.num_target(trial_idx, 1) = num_target;
    DATA_test.count_correct(trial_idx, 1) = count_correct;
    DATA_test.accuracy(trial_idx, 1) = accuracy;
    
    DATA_test.all_circles_final_pos{trial_idx, 1} = all_circles_final_pos;
    DATA_test.target_final_pos{trial_idx, 1} = final_pos;
    DATA_test.click_pos{trial_idx, 1} = click_pos;
    
    % determine whether the trial is completed
    stop_experiment = 1;
    len = size(num_trial_performed, 1);
    for i = 1:len
        if num_trial_performed(i, 1) ~= num_trials_per_level 	% if some trials are missing
            stop_experiment = 0;
        end
    end
end

DATA_test.num_trials_per_level = num_trials_per_level;
DATA_test.num_total_trials = num_total_trials;
DATA_test.speed_coef_x = speed_coef_x;
DATA_test.speed_coef_y = speed_coef_y;

DATA.tests{test_idx} = DATA_test;

WaitSecs(0.3)