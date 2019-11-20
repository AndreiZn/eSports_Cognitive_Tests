function [CFG, DATA] = MEM(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

centerX = CFG_general.centerXY(1,1);
centerY = CFG_general.centerXY(1,2);
win = CFG_general.win;
bgcolor = CFG_general.bgcolor;
grid_size = CFG_test.grid_size;
grid_dim = CFG_test.grid_dim;
line_width = CFG_test.line_width;
target_color = CFG_test.target_color;
grid_color = CFG_test.grid_color;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start experiment
% Show instructions and wait for mouse click/keyboard tap
Display_text(CFG_general, CFG_test.test_instructions(CFG_general.language, :));

HideCursor;

% wait for a click
[~, ~, ~, buttons] = GetClicks([],0,[]);
% wait for button release
while buttons(1)
    [~, ~, buttons] = GetMouse;
    WaitSecs('YieldSecs', 0.01);
end



trial_idx = 0;

for current_num_target = CFG_test.num_min_target:CFG_test.num_max_target
    for idx = 1:CFG_test.num_trials_per_level
        
        trial_idx = trial_idx + 1;
        
        HideCursor;
        grid_pos = [];
        click_pos = [];
        
        % compute centers of each grid
        matrix_center_x = zeros(grid_size);
        matrix_center_y = zeros(grid_size);
        center = (grid_size + 1) / 2;
        lim = center - 1;
        for i = -lim:lim
            for j = -lim:lim
                matrix_center_x(center + j, center + i) = centerX + grid_dim * j;
                matrix_center_y(center + j, center + i) = centerY + grid_dim * i;
            end
        end
        % select target grids randomly
        display_matrix = zeros(grid_size);
        target_counter = 0;
        while 1
            x = randi(grid_size); y = randi(grid_size);
            if display_matrix(x, y) == 1
                continue
            else
                display_matrix(x, y) = 1;
                target_counter = target_counter + 1;
                grid_pos = [grid_pos; x y];
            end
            
            if target_counter == current_num_target
                break
            end
        end
        
        % display targets for some time
        Screen('FillRect', win, bgcolor);
        for i = -lim:lim
            for j = -lim:lim
                if display_matrix(center + j, center + i) == 1
                    Screen('FillRect',win, target_color, [matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                        matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2 ]);
                end
            end
        end
        for i = -lim:lim
            for j = -lim:lim
                Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                    matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, line_width);
                
                Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, ...
                    matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
                
                Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                    matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
                
                Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                    matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
            end
        end
        Screen('Flip',win);
        WaitSecs(CFG_test.grid_display_time);
        
        % clear out the grids
        Screen('FillRect', win, bgcolor);
        for i = -lim:lim
            for j = -lim:lim
                Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                    matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, line_width);
                
                Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, ...
                    matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
                
                Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                    matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
                
                Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                    matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
            end
        end
        Screen('Flip',win);
        
        % wait for mouse clicks
        ShowCursor;
        mouse_count = 0;
        time_Start = GetSecs;
        objects_click_label = zeros(grid_size);
        while mouse_count < current_num_target
            
            Close_screen_if_escKey_pressed(CFG_general.escKey)
            
            [clicks, x, y, whichButton] = GetClicks([],0,[]);
            
            for i = -lim:lim
                for j = -lim:lim
                    if ((x - matrix_center_x(center + j, center + i))^2 + (y - matrix_center_y(center + j, center + i))^2)^0.5 < (grid_dim / 2 * 0.9)
                        if objects_click_label(center + j, center + i) == 0
                            objects_click_label(center + j, center + i) = 1;
                            mouse_count = mouse_count + 1;
                            click_pos = [click_pos; center + j center + i];
                        end
                    end
                end
            end
            
            % display clicked grids
            Screen('FillRect', win ,bgcolor);
            for i = -lim:lim
                for j = -lim:lim
                    if objects_click_label(center + j, center + i) == 1
                        Screen('FillRect',win, target_color, [matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                            matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2 ]);
                    end
                end
            end
            
            for i = -lim:lim
                for j = -lim:lim
                    Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                        matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, line_width);
                    
                    Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, ...
                        matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
                    
                    Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                        matrix_center_x(center + j, center + i) - grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
                    
                    Screen('DrawLine', win, grid_color, matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) - grid_dim / 2, ...
                        matrix_center_x(center + j, center + i) + grid_dim / 2, matrix_center_y(center + j, center + i) + grid_dim / 2, line_width);
                end
            end
            Screen('Flip',win);
        end
        time_Click = GetSecs;
        time_reaction = round((time_Click - time_Start) * 1000);
        
        % compute accuracy
        target_index = find(display_matrix == 1);
        click_index = find(objects_click_label == 1);
        answered_correct = sum(ismember(click_index, target_index));
        accuracy = answered_correct / current_num_target;
        
        DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
        DATA_test.grid_size(trial_idx, 1) = grid_size;
        DATA_test.current_num_target(trial_idx, 1) = current_num_target;
        DATA_test.answered_correct(trial_idx, 1) = answered_correct;
        DATA_test.accuracy(trial_idx, 1) = accuracy;
        DATA_test.time_reaction(trial_idx, 1) = time_reaction;
        DATA_test.grid_pos{trial_idx, 1} = grid_pos;
        DATA_test.click_pos{trial_idx, 1} = click_pos;

        WaitSecs(1);
        
    end
end

DATA_test.num_trials_per_level = CFG_test.num_trials_per_level;
DATA.tests{test_idx} = DATA_test;

WaitSecs(0.3)