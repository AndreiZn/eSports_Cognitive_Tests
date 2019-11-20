function [CFG] = RTM_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Reaction_Mouse';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.num_max_trial = 15;     % number of trials for each number of targets.
CFG.tests{test_idx}.time_display_min = 1;
CFG.tests{test_idx}.time_display_max = 4;
CFG.tests{test_idx}.radius_circle = 110*CFG.general.ratio_pixel;
CFG.tests{test_idx}.rand_pos = 0; % circles always appear in the center
CFG.tests{test_idx}.test_instructions = ...
    {'��������: �������� ����� ������� ���� (���) � ����� ����� �� ������ ��� ��������� �����.', '������� ���, ����� ������ ����.';...
    'Instruction: Click when circles show up.', 'Click to start the experiment.'};
CFG.tests{test_idx}.circle_color = ones(1, CFG.tests{test_idx}.num_max_trial);