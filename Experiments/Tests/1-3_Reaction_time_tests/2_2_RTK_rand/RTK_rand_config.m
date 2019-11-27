function [CFG] = RTK_rand_config(CFG, test_idx)

CFG.tests{test_idx}.experiment_name = 'Reaction_Keyboard_random_pos';
CFG.tests{test_idx}.expected_user_input = 'keyboard';
CFG.tests{test_idx}.num_areas = 5;
CFG.tests{test_idx}.num_trials_per_area = 1; % number of trials per each area (5 areas are defined - see the script Generate_random_coordinates_in_5_areas.m)
CFG.tests{test_idx}.num_trials = CFG.tests{test_idx}.num_areas * CFG.tests{test_idx}.num_trials_per_area;
CFG.tests{test_idx}.time_display_min = 1;
CFG.tests{test_idx}.time_display_max = 4;
CFG.tests{test_idx}.radius_circle = 110*CFG.general.ratio_pixel;
CFG.tests{test_idx}.rand_pos = 1; % circles always appear in the center
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Нажмите пробел при появлении круга на экране.', 'Круги будут появляться в произвольных местах на экране.', 'Нажмите пробел, чтобы начать тест.';...
    'Instruction:  Hit spacebar when circles show up.', 'Circles will appear at random positions of the screen.', 'Hit spacebar to start the experiment.'};
CFG.tests{test_idx}.circle_color = ones(1, CFG.tests{test_idx}.num_trials);