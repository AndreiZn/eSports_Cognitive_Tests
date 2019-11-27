function [CFG] = RTD_rand_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Reaction_with_Decision_random_pos';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.num_areas = 5;
CFG.tests{test_idx}.num_trials_per_area = 10; % number of trials per each area (5 areas are defined - see the script Generate_random_coordinates_in_5_areas.m)
CFG.tests{test_idx}.num_trials = CFG.tests{test_idx}.num_areas * CFG.tests{test_idx}.num_trials_per_area;
CFG.tests{test_idx}.time_display_min = 1;
CFG.tests{test_idx}.time_display_max = 4;
CFG.tests{test_idx}.radius_circle = 110*CFG.general.ratio_pixel;
CFG.tests{test_idx}.rand_pos = 1; % circles always appear in the center
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Щелкните кнопкой мыши при появлении круга.', 'Круги будут появляться в произвольных местах на экране.', 'Красный круг = Левой кнопкой мыши, Синий круг = Правой кнопкой мыши.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: React to the color of circles.', 'Circles will appear at random positions of the screen.', 'Red = Left Click, Blue = Right Click.', 'Click to start the experiment.'};

n_red = round(CFG.tests{test_idx}.num_trials/2);
n_blue = CFG.tests{test_idx}.num_trials - n_red;
color_sequence = [ones(1, n_red) ones(1, n_blue)+2];    % display sequence (red or blue)
rand_index = randperm(length(color_sequence));
color_sequence = color_sequence(rand_index);	% randomize the display sequence
CFG.tests{test_idx}.circle_color = color_sequence;