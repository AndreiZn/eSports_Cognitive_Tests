function [CFG, DATA] = KMC(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

theRect = CFG_general.theRect;
speed_coef = CFG_test.speed_coef;
sensitivity_kb = CFG_test.sensitivity_kb;
centerX = CFG_general.centerXY(1,1);
centerY = CFG_general.centerXY(1,2);
coor_line = [centerX, 0, centerX, theRect(RectBottom)];
radius_circle = CFG_test.radius_circle;
key_w = CFG_general.key_w;
key_a = CFG_general.key_a;
key_s = CFG_general.key_s;
key_d = CFG_general.key_d;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start experiment
% Show instructions and wait for mouse click/keyboard tap
Display_text(CFG_general, CFG_test.test_instructions(CFG_general.language, :));

[~, ~] = Wait_user_input(CFG_general, CFG_test);

HideCursor;

trial_idx = 0;
for num_current_objects = CFG_test.num_min_objects:CFG_test.num_max_objects
    for idx = 1:CFG_test.num_trials_per_level
        
        trial_idx = trial_idx + 1;
        
        Screen('FillRect', CFG_general.win, CFG_general.bgcolor);
        Screen('DrawLine', CFG_general.win, CFG_general.red, coor_line(1), coor_line(2), coor_line(3), coor_line(4), CFG_test.line_width);
        Screen('Flip', CFG_general.win);

        SetMouse(centerX + centerX / 2, centerY + centerY / 2, CFG_general.win);

        pos_kb = [centerX - centerX / 2, centerY + centerY / 2];
        flag_stop = 0;
        flag_collision = NaN;
        
        pos_objects = zeros(num_current_objects * 2, 2);
        v_objects   = zeros(num_current_objects * 2, 2);
        label_region_objects = [zeros(num_current_objects, 1); ones(num_current_objects, 1)];
        
        for i = 1:num_current_objects * 2
            if label_region_objects(i) == 0
                pos_objects(i, 1) = centerX - centerX / 2;
                pos_objects(i, 2) = centerY - centerY / 2;
            else
                pos_objects(i, 1) = centerX + centerX / 2;
                pos_objects(i, 2) = centerY - centerY / 2;
            end
        end
        
        for i = 1:num_current_objects * 2
            v_objects(i, 1) = (0.2 + (1 - 0.2) * rand) * sign(rand - 0.5);
            v_objects(i, 2) = (0.2 + (1 - 0.2) * rand) * sign(rand - 0.5);
        end
        
        time_start = GetSecs;
        while ~flag_stop
            [x_mouse, y_mouse, buttons] = GetMouse(CFG_general.win);
            pos_mouse = [x_mouse y_mouse];
            % constrain mouse circle position within the screen
            pos_mouse(1) = min(pos_mouse(1), theRect(RectRight)  - radius_circle / 2);
            pos_mouse(2) = max(pos_mouse(2), theRect(RectTop)    + radius_circle / 2);
            pos_mouse(2) = min(pos_mouse(2), theRect(RectBottom) - radius_circle / 2);
            
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                if     keyCode(key_w) && keyCode(key_a)
                    pos_kb_increment = [-1, -1];
                elseif keyCode(key_w) && keyCode(key_d)
                    pos_kb_increment = [1, -1];
                elseif keyCode(key_s) && keyCode(key_a)
                    pos_kb_increment = [-1 , 1];
                elseif keyCode(key_s) && keyCode(key_d)
                    pos_kb_increment = [1, 1];
                elseif keyCode(key_w)
                    pos_kb_increment = [0, -1];
                elseif keyCode(key_s)
                    pos_kb_increment = [0, 1];
                elseif keyCode(key_a)
                    pos_kb_increment = [-1, 0];
                elseif keyCode(key_d)
                    pos_kb_increment = [1, 0];
                else
                    pos_kb_increment = [0, 0];
                end
            else
                pos_kb_increment = [0, 0];
            end
            pos_kb = pos_kb + pos_kb_increment * sensitivity_kb;
            % constrain keyboard circle position within the screen
            pos_kb(1) = max(pos_kb(1), theRect(RectLeft)   + radius_circle / 2);
            pos_kb(2) = max(pos_kb(2), theRect(RectTop)    + radius_circle / 2);
            pos_kb(2) = min(pos_kb(2), theRect(RectBottom) - radius_circle / 2);
            
            for i = 1:num_current_objects * 2
                pos_objects(i, 1) = pos_objects(i, 1) + v_objects(i, 1) * speed_coef;
                pos_objects(i, 2) = pos_objects(i, 2) + v_objects(i, 2) * speed_coef;
                
                if label_region_objects(i) == 0
                    % bounce back if the circles touch the edge of screen
                    if pos_objects(i, 1) < (theRect(RectLeft) + radius_circle / 2) || pos_objects(i, 1) > (theRect(RectRight) / 2 - radius_circle / 2)
                        v_objects(i, 1) = -v_objects(i, 1);
                        pos_objects(i, 1) = pos_objects(i, 1) + v_objects(i, 1) * 2;
                    end
                    
                    if pos_objects(i, 2) < (theRect(RectTop) + radius_circle / 2) || pos_objects(i, 2) > (theRect(RectBottom) - radius_circle / 2)
                        v_objects(i, 2) = -v_objects(i, 2);
                        pos_objects(i, 2) = pos_objects(i, 2) + v_objects(i, 2) * 2;
                    end
                else
                    % bounce back if the circles touch the edge of screen
                    if pos_objects(i, 1) < (theRect(RectRight) / 2 + radius_circle / 2) || pos_objects(i, 1) > (theRect(RectRight) - radius_circle / 2)
                        v_objects(i, 1) = -v_objects(i, 1);
                        pos_objects(i, 1) = pos_objects(i, 1) + v_objects(i, 1) * 2;
                    end
                    
                    if pos_objects(i, 2) < (theRect(RectTop) + radius_circle / 2) || pos_objects(i, 2) > (theRect(RectBottom) - radius_circle / 2)
                        v_objects(i, 2) = -v_objects(i, 2);
                        pos_objects(i, 2) = pos_objects(i, 2) + v_objects(i, 2) * 2;
                    end
                end
            end
            
            time_lasted = round(GetSecs - time_start, 2);
            % update drawing
            % back ground
            Screen('FillRect', CFG_general.win, CFG_general.bgcolor);
            
            % mid line
            Screen('DrawLine', CFG_general.win, CFG_general.red, coor_line(1), coor_line(2), coor_line(3), coor_line(4), CFG_test.line_width);
            
            % moving circles
            for i = 1:num_current_objects * 2
                Screen('FillOval', CFG_general.win, CFG_general.red, [pos_objects(i, 1) - radius_circle / 2, pos_objects(i, 2) - radius_circle / 2, ...
                    pos_objects(i, 1) + radius_circle / 2, pos_objects(i, 2) + radius_circle / 2]);
                Screen('FrameOval', CFG_general.win, CFG_general.red, [pos_objects(i, 1) - radius_circle / 2, pos_objects(i, 2) - radius_circle / 2, ...
                    pos_objects(i, 1) + radius_circle / 2, pos_objects(i, 2) + radius_circle / 2], 5);
            end
            
            % mouse circle
            frame_mouse = [pos_mouse(1) - radius_circle / 2, pos_mouse(2) - radius_circle / 2, pos_mouse(1) + radius_circle / 2, pos_mouse(2) + radius_circle / 2];
            Screen('FillOval',  CFG_general.win, CFG_general.blue, frame_mouse);
            Screen('FrameOval', CFG_general.win, CFG_general.black, frame_mouse, 5);
            
            % keyboard circle
            frame_kb = [pos_kb(1) - radius_circle / 2, pos_kb(2) - radius_circle / 2, pos_kb(1) + radius_circle / 2, pos_kb(2) + radius_circle / 2];
            Screen('FillOval',  CFG_general.win, CFG_general.blue, frame_kb);
            Screen('FrameOval', CFG_general.win, CFG_general.black, frame_kb, 5);
            
            % show time lasted
            Screen('TextSize', CFG_general.win, CFG_general.font_size);
            display_text = ['Time lasted: ', num2str(time_lasted)];
            Screen('DrawText', CFG_general.win, display_text, 50, 50, CFG_general.textcolor);
            Screen('Flip', CFG_general.win);
            
            % stop if the controlled circles touch the mid line
            if abs(pos_mouse(1) - coor_line(1)) < (radius_circle / 2)
                flag_stop = 1;
                flag_collision = 1; % collision by mosue
            end
            
            if abs(pos_kb(1) - coor_line(1)) < (radius_circle / 2)
                flag_stop = 1;
                flag_collision = 0; % collision by keyboard
            end
            
            % stop if the controlled circles touch the moving circles
            for i = 1:num_current_objects * 2
                if label_region_objects(i) == 0
                    if ((pos_kb(1) - pos_objects(i, 1))^2 + (pos_kb(2) - pos_objects(i, 2))^2)^0.5 < (radius_circle)
                        flag_stop = 1;
                        flag_collision = 0; % collision by keyboard
                    end
                else
                    if ((pos_mouse(1) - pos_objects(i, 1))^2 + (pos_mouse(2) - pos_objects(i, 2))^2)^0.5 < (radius_circle)
                        flag_stop = 1;
                        flag_collision = 1; % collision by mosue
                    end
                end
            end
            
            Close_screen_if_escKey_pressed(CFG_general.escKey)
            
            WaitSecs(1 / CFG_general.frame_rate);
        end

        
        DATA_test.num_current_objects(trial_idx, 1) = num_current_objects;
        DATA_test.flag_collision(trial_idx, 1) = flag_collision;
        DATA_test.time_lasted(trial_idx, 1) = time_lasted;
        DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF'); 
        
        WaitSecs(1);
    end
end

DATA_test.num_trials_per_level = CFG_test.num_trials_per_level;
DATA.tests{test_idx} = DATA_test;

WaitSecs(0.3)