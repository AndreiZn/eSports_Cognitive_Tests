function [CFG] = RTD_rand_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Reaction_with_Decision_random_pos';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.num_max_trial = 15;     % number of trials for each number of targets.
CFG.tests{test_idx}.time_display_min = 1;
CFG.tests{test_idx}.time_display_max = 4;
CFG.tests{test_idx}.radius_circle = 110*CFG.general.ratio_pixel;
CFG.tests{test_idx}.rand_pos = 1; % circles always appear in the center
CFG.tests{test_idx}.test_instructions = ...
    {'��������: �������� ������� ���� ��� ��������� �����.', '����� ����� ���������� � ������������ ������ �� ������.', '������� ���� = ����� ������� ����, ����� ���� = ������ ������� ����.', '������� ���, ����� ������ ����.';...
    'Instruction: React to the color of circles.', 'Circles will appear at random positions of the screen.', 'Red = Left Click, Blue = Right Click.', 'Click to start the experiment.'};

n_red = round(CFG.tests{test_idx}.num_max_trial/2);
n_blue = CFG.tests{test_idx}.num_max_trial - n_red;
color_sequence = [ones(1, n_red) ones(1, n_blue)+2];    % display sequence (red or blue)
rand_index = randperm(length(color_sequence));
color_sequence = color_sequence(rand_index);	% randomize the display sequence
CFG.tests{test_idx}.circle_color = color_sequence;