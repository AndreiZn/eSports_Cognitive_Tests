function [CFG] = RTK_config(CFG, test_idx)

CFG.tests{test_idx}.experiment_name = 'Reaction_Keyboard';
CFG.tests{test_idx}.expected_user_input = 'keyboard';
CFG.tests{test_idx}.num_trials = 3; % number of trials for the experiment
CFG.tests{test_idx}.time_display_min = 1;
CFG.tests{test_idx}.time_display_max = 4;
CFG.tests{test_idx}.radius_circle = 110*CFG.general.ratio_pixel;
CFG.tests{test_idx}.rand_pos = 0; % circles always appear in the center
CFG.tests{test_idx}.test_instructions = ...
    {'��������: ������� ������ ��� ��������� ����� �� ������.', '������� ������, ����� ������ ����.';...
    'Instruction:  Hit spacebar when circles show up.', 'Hit spacebar to start the experiment.'};
CFG.tests{test_idx}.circle_color = ones(1, CFG.tests{test_idx}.num_trials);