function [CFG, DATA] = VS(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

win = CFG_general.win;
centerXY = CFG_general.centerXY;
bgcolor = CFG_general.bgcolor;
textcolor = CFG_general.textcolor;
font_size = CFG_general.font_size;
grid_size = CFG_test.grid_size;
grid_dim = CFG_test.grid_dim;
offset_x = CFG_test.offset_x;
offset_y = CFG_test.offset_y;
text_size = CFG_test.text_size;

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

pos_x = 0;
pos_y = 0;
current_score = 0;
trial_idx = 0;
time_Start_exp = GetSecs;
while (GetSecs - time_Start_exp) < CFG_test.time_limit
    
    trial_idx = trial_idx + 1;
    display_matrix = rand(grid_size);
    display_matrix(display_matrix > CFG_test.truncate_prob) = 1;
    display_matrix(display_matrix < CFG_test.truncate_prob) = 0;
    display_matrix = 1 - display_matrix;
    
    % insert letter L with prob = 0.5
    if rand() > 0.5
        correct_ans = 1;
        while 1
            x = randi(grid_size); y = randi(grid_size);
            if display_matrix(x, y) == 1
                display_matrix(x, y) = 2;
                pos_x = x;
                pos_y = y;
                break;
            end
        end
    else
        correct_ans = 3;
        pos_x = 0;
        pos_y = 0;
    end
 
    Screen('FillRect', win, bgcolor);
    %Screen('TextSize', win, text_size);
    
    center = (grid_size + 1) / 2;
    lim = center - 1;
    for i = -lim:lim
        for j = -lim:lim
            if display_matrix(center + j, center + i) == 1
                Screen('DrawText',win,['T'] , centerXY(1) + grid_dim * j + offset_x, centerXY(2) + grid_dim * i + offset_y, textcolor);
            elseif display_matrix(center + j, center + i) == 2
                Screen('DrawText',win,['L'] , centerXY(1) + grid_dim * j + offset_x, centerXY(2) + grid_dim * i + offset_y, textcolor);
            end
        end
    end
    Screen('DrawText',win,['Current Score: ' num2str(current_score)] , 100 + offset_x, 100 + offset_y, textcolor);
    time_Start = Screen('Flip',win);

    [clicks, x, y, whichButton] = GetClicks([],0,[]);
    
    time_Click = GetSecs;
    time_reaction = time_Click - time_Start;
    clicked_button = whichButton;
    if whichButton == correct_ans
        answered_correct = 1;
        current_score = current_score + 1;
    else
        answered_correct = 0;
        current_score = current_score - 1;
    end
     
    DATA_test.display_matrix{trial_idx, 1} = display_matrix;
    DATA_test.grid_size(trial_idx, 1) = grid_size;
    DATA_test.correct_ans(trial_idx, 1) = correct_ans;
    DATA_test.answered_correct(trial_idx, 1) = answered_correct;
    DATA_test.time_reaction(trial_idx, 1) = time_reaction;
    DATA_test.pos_x(trial_idx, 1) = pos_x;
    DATA_test.pos_y(trial_idx, 1) = pos_y;
    DATA_test.current_score(trial_idx, 1) = current_score;
    DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
    
    Close_screen_if_escKey_pressed(CFG_general.escKey)
    
end

DATA_test.final_score = DATA_test.current_score(end, 1);
DATA.tests{test_idx} = DATA_test;

if CFG_test.flag_show_score
    display_text = ['Your score: ' num2str(current_score)];
    Screen('DrawText', win, display_text, centerXY(1) - floor(length(display_text) * font_size / 4), centerXY(2) + 120,textcolor);
end

Screen('Flip',win);
WaitSecs(1);
