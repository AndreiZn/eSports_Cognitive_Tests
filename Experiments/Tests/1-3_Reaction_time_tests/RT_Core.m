function [DATA] = RT_Core(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

r_c = CFG_test.radius_circle;
c_color = CFG_test.circle_color;

Screen('FillRect', CFG_general.win, CFG_general.bgcolor);
Screen('Flip', CFG_general.win);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start experiment
% Show instructions and wait for mouse click/keyboard tap
Display_text(CFG_general, CFG_test.test_instructions(CFG_general.language, :));

% Wait for mouse click or spacebar tap (depends on config)
[~, ~] = Wait_user_input(CFG_general, CFG_test);

HideCursor;

if CFG_test.rand_pos
    [circle_coordinates] = Generate_random_coordinates_in_5_areas(CFG, test_idx);
end

for trial_idx = 1:CFG.tests{test_idx}.num_trials
    
    time_last_click = GetSecs;
    target_presented = 0;
    
    r = randi([CFG_test.time_display_min, CFG_test.time_display_max]);
    while ~target_presented
        
        Screen('FillRect', CFG_general.win, CFG_general.bgcolor);
        Screen('Flip', CFG_general.win);
        
        if ~CFG_test.rand_pos
            object_x = CFG_general.centerXY(1,1);
            object_y = CFG_general.centerXY(1,2);
        else
            object_x = circle_coordinates(trial_idx,1);
            object_y = circle_coordinates(trial_idx,2);
        end
        
        DATA_test.target_pos(trial_idx, :) = [object_x, object_y];
        
        if GetSecs - time_last_click >= r
              
            if c_color(trial_idx) == 1 % red
                Screen('FillOval', CFG_general.win, CFG_general.red, [object_x - r_c/2, object_y - r_c/2, object_x + r_c/2, object_y + r_c/2]);
            else % blue
                Screen('FillOval', CFG_general.win, CFG_general.blue, [object_x - r_c/2, object_y - r_c/2, object_x + r_c/2, object_y + r_c/2]);
            end
            Screen('FrameOval', CFG_general.win, CFG_general.black, [object_x - r_c/2, object_y - r_c/2, object_x + r_c/2, object_y + r_c/2], 5);
            time_target_presented = Screen('Flip', CFG_general.win);
            
            [time_click, whichButton] = Wait_user_input(CFG_general, CFG_test);
            target_presented = 1;
            
            DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
            DATA_test.reaction_time(trial_idx, 1) = round((time_click - time_target_presented) * 1000);
            DATA_test.time_target_appearance(trial_idx, 1) = time_target_presented;
            DATA_test.time_click(trial_idx, 1) = time_click;
            if strcmp(CFG_test.expected_user_input, 'mouse')
                DATA_test.which_button(trial_idx, 1) = whichButton;
            end
        end
         
        Close_screen_if_escKey_pressed(CFG_general.escKey)
            
    end
end

DATA_test.num_trials = CFG_test.num_trials;
DATA_test.color_sequence = c_color;
DATA.tests{test_idx} = DATA_test;

WaitSecs(0.1)