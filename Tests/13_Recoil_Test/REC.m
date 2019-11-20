%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   RecoilPatternControl.m     Feb 06, 2019
%   This test checks the ability to control recoil of a gun (AK-47)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CFG, DATA] = REC(CFG, DATA, test_idx)

CFG_general = CFG.general;
CFG_test = CFG.tests{test_idx};

theRect = CFG_general.theRect;
font_size = CFG_general.font_size;
centerXY = CFG_general.centerXY;
RPC.CSGO_coef = CFG_test.CSGO_coef;
RPC.sensitivity_skip_factor = 2.2 * CFG_test.CSGO_coef;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % start experiment

HideCursor;

RPC.spaceKey = CFG_general.spaceKey; RPC.escKey = CFG_general.escKey;
RPC.LeftArrowKey = CFG_general.LeftArrowKey; RPC.RightArrowKey = CFG_general.RightArrowKey;
spaceKey = RPC.spaceKey; escKey = RPC.escKey;
RPC.gray = CFG_general.gray;
bgcolor = CFG_general.bgcolor; RPC.textcolor = CFG_general.textcolor; textcolor = CFG_general.textcolor;
RPC.mainwin = CFG_general.win;
mainwin = RPC.mainwin;
RPC.theRect = CFG_general.theRect;
Screen('FillRect', RPC.mainwin, bgcolor);
Screen('Flip', RPC.mainwin);
center = [RPC.theRect(RectRight)/2 RPC.theRect(RectBottom)/2];

% RPC is a structure that keeps parameters used in outer functions
RPC.im = CFG_test.im;
RPC.target = Screen('MakeTexture', RPC.mainwin, RPC.im);
% Experimental parameters
num_repetitions_train = CFG_test.num_repetitions_train;
num_repetitions_test = CFG_test.num_repetitions_test;
shots_to_kill_array = CFG_test.shots_to_kill_array;
RPC.cursor_length = CFG_test.cursor_length;
RPC.sensitivity_skip_factor = CFG_test.sensitivity_skip_factor;
RPC.bullet_trajectory = CFG_test.bullet_trajectory;
RPC.aim_marker_radius = CFG_test.aim_marker_radius;
RPC.target_size = CFG_test.target_size;

RPC.target_pos = centerXY;
RPC.shots_per_second = CFG_test.shots_per_second;

RPC.allPoints = [];
RPC.trajectory_iterator = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Experimental instructions, wait for a spacebar response to start
Screen('FillRect', mainwin, bgcolor);
Screen('TextSize', mainwin, font_size);
Screen('DrawText',mainwin, ['Shoot at targets as many times as indicated near each target.'] ,center(1)-450,center(2)-100,textcolor);
Screen('DrawText',mainwin, ['Use single-shot or continious modes.'] ,center(1)-450,center(2)-60,textcolor);
Screen('DrawText',mainwin, ['Press spacebar to continue.'] ,center(1)-450,center(2)-20,textcolor);
Screen('Flip',mainwin );

wait_user_reaction(spaceKey, escKey)
HideCursor;



%%%%%%%%%% TRAINING START %%%%%%%%%%
Screen('DrawText',mainwin, ['Training trials.'] ,center(1)-450,center(2)-100,textcolor);
Screen('DrawText',mainwin, ['These results will not be taken into account.'] ,center(1)-450,center(2)-60,textcolor);
Screen('DrawText',mainwin, ['You can adjust sensitivity by pressing left and right arrows.'] ,center(1)-450,center(2)-20,textcolor);
Screen('DrawText',mainwin, ['Press spacebar to start the experiment.'] ,center(1)-450,center(2)+20,textcolor);
Screen('Flip',mainwin );
wait_user_reaction(spaceKey, escKey)

% Move the cursor to the center of the screen
theX = round(theRect(RectRight) / 2);
theY = round(theRect(RectBottom) / 2);
SetMouse(theX,theY,mainwin);

% Set up training
num_repetitions = num_repetitions_train;
sample = repmat(shots_to_kill_array, num_repetitions, 1);
RPC.shots_to_kill_array = datasample(sample(:), num_repetitions*numel(shots_to_kill_array), 'Replace', false);
RPC.num_trials = numel(RPC.shots_to_kill_array);

% Create a struct vatiable to save data to it later
recoil_test_data = prepare_data_struct(RPC);

% Start test
[RPC, ~] = RecoilTestCore(RPC, recoil_test_data);
%%%%%%%%%% TRAINING END %%%%%%%%%%





%%%%%%%%%% TESTING START %%%%%%%%%%
Screen('DrawText',mainwin, ['Testing trials.'] ,center(1)-450,center(2)-100,textcolor);
Screen('DrawText',mainwin, ['Press spacebar to start the experiment.'] ,center(1)-450,center(2)-60,textcolor);
Screen('Flip',mainwin );
wait_user_reaction(spaceKey, escKey)

% Set up test
num_repetitions = num_repetitions_test;
sample = repmat(shots_to_kill_array, num_repetitions, 1);
RPC.shots_to_kill_array = datasample(sample(:), num_repetitions*numel(shots_to_kill_array), 'Replace', false);
RPC.num_trials = numel(RPC.shots_to_kill_array);

% Create a struct vatiable to save data to it later
recoil_test_data = prepare_data_struct(RPC);

% Start test
[~, recoil_test_data] = RecoilTestCore(RPC, recoil_test_data);

%CFG.tests{test_idx}.sensitivity_skip_factor = RPC.sensitivity_skip_factor;
DATA.tests{test_idx} = recoil_test_data;
DATA.tests{test_idx}.test_name = CFG.general.short_names{test_idx};
%%%%%%%%%% TESTING END %%%%%%%%%%

end

function [RPC, recoil_test_data] = RecoilTestCore(RPC, recoil_test_data)

cursor_length = RPC.cursor_length;
bullet_trajectory = RPC.bullet_trajectory;
aim_marker_radius = RPC.aim_marker_radius;
target_size = RPC.target_size;
target_pos = RPC.target_pos;
shots_per_second = RPC.shots_per_second;
shots_to_kill_array = RPC.shots_to_kill_array;
num_trials = RPC.num_trials;
mainwin = RPC.mainwin;
target = RPC.target;
theRect = RPC.theRect;
textcolor = RPC.textcolor;
CSGO_coef = RPC.CSGO_coef;
sensitivity_skip_factor = RPC.sensitivity_skip_factor;
LeftArrowKey = RPC.LeftArrowKey;
RightArrowKey = RPC.RightArrowKey;
gray = RPC.gray;
allPoints = [];
trajectory_iterator = 1;
[~, ~, buttons] = GetMouse;
mostrecent_shot_time = GetSecs;

timeStart = GetSecs;

for current_trial=1:num_trials
    
    escKey = RPC.escKey;
    recoil_test_data.target_pos(current_trial, :) = target_pos;
    shots_pos = [];
    trial_mouse_traj = [];
    killed = 0;
    shots_to_kill = shots_to_kill_array(current_trial);
    recoil_test_data.shots_to_kill(current_trial, 1) = shots_to_kill;
    shots_counter = 0;
    accurate_shots_counter = 0;
    first_shot_flag = 1;
    [x_mouse,y_mouse,~] = GetMouse;
    recoil_test_data.num_bursts(current_trial,1) = 0;
    last_shot_flag = 1;
    click_button_pressed = 1;
    
    if buttons(1)
        while click_button_pressed
            click_last_flag = buttons(1);
            [~, ~, buttons] = GetMouse;
            
            if click_last_flag && ~buttons(1)
                click_button_pressed = 0;
            end
        end
    end
    
    recoil_test_data.time_target_appearance(current_trial,1) = GetSecs;
    
    while ~killed
        
        [~, ~, keyCode] = KbCheck;
        if keyCode(RightArrowKey)
            WaitSecs(0.15)
            sensitivity_skip_factor = sensitivity_skip_factor + 0.05*CSGO_coef;
        elseif keyCode(LeftArrowKey)
            WaitSecs(0.15)
            sensitivity_skip_factor = sensitivity_skip_factor - 0.05*CSGO_coef;
        end
        
        tp = target_pos; ts = target_size;
        Screen('DrawTexture', mainwin, target, [], ...
            [tp(1)-ts(1)/2,tp(2)-ts(2)/2, tp(1)+ts(1)/2, tp(2)+ts(2)/2]);
        
        display_text = ['Time Elapsed: ', num2str(round((GetSecs - timeStart),2)), 'sec'];
        Screen('TextSize', mainwin, 20);
        Screen('DrawText',mainwin, display_text, 0.8*theRect(3), 0.05*theRect(4), [120 0 0]);
        display_sens_text = ['Sensitivity (400DPI): ', num2str(round(sensitivity_skip_factor/CSGO_coef, 2))];
        Screen('DrawText', mainwin, display_sens_text, 0.8*theRect(3), 0.01*theRect(4), [120 0 0]);
        
        x_curr = x_mouse; y_curr = y_mouse;
        [x_mouse,y_mouse,buttons] = GetMouse;
        x_diff_mouse = x_mouse - x_curr; y_diff_mouse = y_mouse - y_curr;
        x_mouse = x_curr + sensitivity_skip_factor*x_diff_mouse;
        y_mouse = y_curr + sensitivity_skip_factor*y_diff_mouse;
        SetMouse(x_mouse, y_mouse)
        
        trial_mouse_traj = [trial_mouse_traj; x_mouse y_mouse];
        allPoints = [allPoints; x_mouse y_mouse];
        
        if ~buttons(1)
            first_shot_flag = 1;
            trajectory_iterator = 1;
            if ~isempty(shots_pos)&&last_shot_flag
                recoil_diff_1ststep = bullet_trajectory(4, :) - bullet_trajectory(1, :);
                SetMouse(x_mouse + recoil_diff_1ststep(1, 1), y_mouse + recoil_diff_1ststep(1, 2));
                last_shot_flag = 0;
            end
        end
        
        if buttons(1) && ~killed && GetSecs - mostrecent_shot_time > 1/shots_per_second
            
            mostrecent_shot_time = GetSecs;
            shots_counter = shots_counter + 1;
            last_shot_flag = 1;
            
            x_diff_traj = bullet_trajectory(trajectory_iterator, 1) - bullet_trajectory(1, 1);
            y_diff_traj = bullet_trajectory(trajectory_iterator, 2) - bullet_trajectory(1, 2);
            trajectory_iterator = trajectory_iterator + 1;
            
            if first_shot_flag
                first_shot_flag = 0;
                time_first_shot = GetSecs;
                recoil_test_data.num_bursts(current_trial,1) = recoil_test_data.num_bursts(current_trial,1) + 1;
                recoil_test_data.time_to_reach_target(current_trial, 1) = time_first_shot - recoil_test_data.time_target_appearance(current_trial,1);
            end
            
            x_shot = x_mouse + x_diff_traj;
            y_shot = y_mouse + y_diff_traj;
            shots_pos = [shots_pos; x_shot y_shot];
            %SetMouse(x,y);
            
            if sqrt((x_shot-target_pos(1))^2 + (y_shot-target_pos(2))^2) < target_size(1)/2
                accurate_shots_counter = accurate_shots_counter + 1;
            end
            
            if accurate_shots_counter >= shots_to_kill
                recoil_test_data.time_to_kill(current_trial, 1) = GetSecs - time_first_shot;
                %t_to_kill = GetSecs - t_target_presented;
                killed = 1;
                recoil_test_data.shots_used(current_trial, 1) = shots_counter;
                recoil_test_data.time_target_killed(current_trial,1) = GetSecs;
                recoil_test_data.shots_pos{current_trial, 1} = shots_pos;
            end
            
            if trajectory_iterator > size(bullet_trajectory,1)
                trajectory_iterator = 1;
                WaitSecs(0.3)
            end
            
        end
        
        display_text = num2str(shots_to_kill - accurate_shots_counter);
        Screen('DrawText',mainwin, display_text, target_pos(1)+target_size(1)/2,target_pos(2)+target_size(2)/2, textcolor);
        
        
        for point_idx = 1:size(shots_pos,1)
            x_sh_draw = shots_pos(point_idx,1);
            y_sh_draw = shots_pos(point_idx,2);
            Screen('FillOval',  mainwin, gray, ...
                [x_sh_draw-aim_marker_radius/2, y_sh_draw-aim_marker_radius/2,...
                x_sh_draw+aim_marker_radius/2, y_sh_draw+aim_marker_radius/2]);
        end
        
        Screen('DrawLine',  mainwin, [256], x_mouse - cursor_length/2, y_mouse, x_mouse + cursor_length/2, y_mouse, 3);
        Screen('DrawLine',  mainwin, [256], x_mouse, y_mouse - cursor_length/2, x_mouse, y_mouse + cursor_length/2, 3);
        Screen('Flip',mainwin);
        
        
        [~, ~, keyCode] = KbCheck;
        if keyCode(escKey)
            ShowCursor;
            Screen('CloseAll');
            break;
        end
        
    end
    target_pos(1) = 2*target_size(1) + rand*(theRect(3) - 4*target_size(1));
    target_pos(2) = 2*target_size(2) + rand*(theRect(4) - 4*target_size(2));
    recoil_test_data.trialwise_mouse_trajectory{current_trial,1} = trial_mouse_traj;
    WaitSecs(0.5)
end
recoil_test_data.complete_mouse_trajectory = allPoints;
recoil_test_data.time_elapsed = GetSecs - timeStart;
recoil_test_data.sensitivity = sensitivity_skip_factor;
RPC.sensitivity_skip_factor = sensitivity_skip_factor; % save selected sensitivity_skip_factor
end

function [recoil_test_data] = prepare_data_struct(RPC)

num_trials = RPC.num_trials;

recoil_test_data = struct();

recoil_test_data.target_pos = zeros(num_trials, 2); % position of targets
recoil_test_data.shots_pos = cell(num_trials,1); % position of shots
recoil_test_data.shots_to_kill = zeros(num_trials, 1); % required number of shots
recoil_test_data.shots_used = zeros(num_trials, 1); % used number of shots (>= required)
recoil_test_data.time_target_appearance = zeros(num_trials, 1); % absolute time when a target appeared
recoil_test_data.time_target_killed = zeros(num_trials, 1); % absolute time when a target was killed
recoil_test_data.time_to_reach_target = zeros(num_trials, 1); % time when a target was reached
recoil_test_data.time_to_kill = zeros(num_trials, 1); % time from the first shot till the last one
recoil_test_data.time_elapsed = 0; % time required for all trials
recoil_test_data.num_bursts = zeros(num_trials, 1); % each target can be killed in one continious shooting (one burst) or in several bursts
recoil_test_data.trialwise_mouse_trajectory = cell(num_trials,1);
recoil_test_data.complete_mouse_trajectory = [];
end

function wait_user_reaction(spaceKey, escKey)
while 1
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            break ;
        elseif keyCode(escKey)
            ShowCursor;
            Screen('CloseAll');
            return;
        end
    end
end
WaitSecs(0.3);
end
