function [CFG] = RTM_rand_config(CFG, test_idx)

CFG.tests{test_idx}.experiment_name = 'Reaction_Mouse_random_pos';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.num_max_trial = 15;     % number of trials for each number of targets.
CFG.tests{test_idx}.time_display_min = 1;
CFG.tests{test_idx}.time_display_max = 4;
CFG.tests{test_idx}.radius_circle = 110*CFG.general.ratio_pixel;
CFG.tests{test_idx}.rand_pos = 1; % circles appear at random positions
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Щелкните левой кнопкой мыши (ЛКМ) в любое место на экране при появлении круга.', 'Круги будут появляться в произвольных местах на экране. ', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: Click when circles show up.', 'Circles will appear at random positions of the screen.', 'Click to start the experiment.'};
CFG.tests{test_idx}.circle_color = ones(1, CFG.tests{test_idx}.num_max_trial);