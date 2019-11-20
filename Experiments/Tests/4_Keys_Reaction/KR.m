function [CFG, DATA] = KR(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start experiment
% Show instructions and wait for mouse click/keyboard tap
Display_text(CFG_general, CFG_test.test_instructions(CFG_general.language, :));

[~, ~] = Wait_user_input(CFG_general, CFG_test);
Screen('FillRect', CFG_general.win, CFG_general.bgcolor);
Screen('Flip', CFG_general.win);
WaitSecs(0.5)

HideCursor;

sequence_display = {};
sequence_correct_key = [];

flag_repeated = 1;
while flag_repeated
    sequence_initial = randi(7, 1, CFG_test.num_display_row);
    % diff function computes the difference between 2 succesive elements in the array
    % if the difference is 0, it means there are repeated number in the adjacent positions
    if ismember(0, diff(sequence_initial))
        flag_repeated = 1;
    else
        flag_repeated = 0;
    end
end

for i = 1:CFG_test.num_display_row
    
    switch sequence_initial(i)
        case 1
            key_text = 'w';
            key_correst = CFG_general.key_w;
        case 2
            key_text = 's';
            key_correst = CFG_general.key_s;
        case 3
            key_text = 'a';
            key_correst = CFG_general.key_a;
        case 4
            key_text = 'd';
            key_correst = CFG_general.key_d;
        case 5
            key_text = 'shift';
            key_correst = CFG_general.key_shift;
        case 6
            key_text = 'ctrl';
            key_correst = CFG_general.key_ctrl;
        case 7
            key_text = 'space';
            key_correst = CFG_general.spaceKey;
    end
    
    sequence_display = [sequence_display; key_text];
    sequence_correct_key = [sequence_correct_key; key_correst];
end

for trial_idx=1:CFG_test.num_max_trial
    
    num_mistakes = 0;
    display_text = [];
    for i = 1:CFG_test.num_display_row
        display_text = [display_text, sequence_display{i}, '    '];
    end
    
    Screen('DrawText', CFG_general.win, display_text, ...
        CFG_general.centerXY(1,1) - floor(length(display_text) * CFG_general.font_size / 4), ...
        CFG_general.centerXY(1,2) - 40, CFG_general.textcolor);
    time_Start = Screen('Flip', CFG_general.win);
    
    keyunpressed = 0; % key is lifted up (unpressed)
    [keyIsDown, ~, ~] = KbCheck;
    while 1
        
        keyIsDown_last = keyIsDown;
        [keyIsDown, secs, keyCode] = KbCheck;
        
        if keyIsDown_last && ~keyIsDown
            keyunpressed = 0;
        end
        
        if keyIsDown
            if keyCode(sequence_correct_key(1))
                break;
            elseif keyCode(CFG_general.escKey)
                ShowCursor;
                Screen('CloseAll');
                return;
            elseif ~keyunpressed
                num_mistakes = num_mistakes + 1;
                keyunpressed = 1;
            end
        end
    end
    
    while 1
        [keyIsDown, ~, ~] = KbCheck;
        if ~keyIsDown
            DATA_test.reaction_time(trial_idx, 1) = round((secs - time_Start) * 1000);
            DATA_test.time{trial_idx, 1} = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
            DATA_test.displayed_letter{trial_idx, 1} = sequence_display{1};
            DATA_test.num_mistakes(trial_idx, 1) = num_mistakes;
            
            flag_repeated = 1;
            while flag_repeated
                tmp = randi(7);
                switch tmp
                    case 1
                        key_text = 'w';
                        key_correst = CFG_general.key_w;
                    case 2
                        key_text = 's';
                        key_correst = CFG_general.key_s;
                    case 3
                        key_text = 'a';
                        key_correst = CFG_general.key_a;
                    case 4
                        key_text = 'd';
                        key_correst = CFG_general.key_d;
                    case 5
                        key_text = 'shift';
                        key_correst = CFG_general.key_shift;
                    case 6
                        key_text = 'ctrl';
                        key_correst = CFG_general.key_ctrl;
                    case 7
                        key_text = 'space';
                        key_correst = CFG_general.spaceKey;
                end
                
                if strcmp(key_text, sequence_display{end})
                    flag_repeated = 1;
                else
                    flag_repeated = 0;
                end
            end
            sequence_display(1) = [];
            sequence_correct_key(1) = [];
            sequence_display = [sequence_display; key_text];
            sequence_correct_key = [sequence_correct_key; key_correst];
            
            break;
        end
        
    end
end

DATA_test.num_trials = CFG_test.num_max_trial;
DATA.tests{test_idx} = DATA_test;
