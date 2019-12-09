function [CFG] = KR_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Keys_Reaction';
CFG.tests{test_idx}.expected_user_input = 'keyboard';
CFG.tests{test_idx}.num_max_trial = 100;
CFG.tests{test_idx}.num_display_row = 10;
CFG.tests{test_idx}.test_instructions = ...
    {'��������: ��������� �������, ��������� �� ������.', '������� ������, ����� ������ ����.';...
    'Instruction: Hit keys corresponding to the text displayed on screen.', 'Hit spacebar to start the experiment.'};