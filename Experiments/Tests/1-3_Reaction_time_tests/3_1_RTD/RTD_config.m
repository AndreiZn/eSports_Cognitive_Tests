function [CFG] = RTD_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Reaction_with_Decision';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.num_trials = 30; % number of trials for the experiment
CFG.tests{test_idx}.time_display_min = 1;
CFG.tests{test_idx}.time_display_max = 4;
CFG.tests{test_idx}.radius_circle = 110*CFG.general.ratio_pixel;
CFG.tests{test_idx}.rand_pos = 0; % circles always appear in the center
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Щелкните кнопкой мыши при появлении круга.', 'Красный круг = Левой кнопкой мыши, Синий круг = Правой кнопкой мыши.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: React to the color of circles.', 'Red = Left Click, Blue = Right Click.', 'Click to start the experiment.'};

n_red = round(CFG.tests{test_idx}.num_trials/2);
n_blue = CFG.tests{test_idx}.num_trials - n_red;
color_sequence = [ones(1, n_red) ones(1, n_blue)+2];    % display sequence (red or blue)
rand_index = randperm(length(color_sequence));
color_sequence = color_sequence(rand_index);	% randomize the display sequence
CFG.tests{test_idx}.circle_color = color_sequence;