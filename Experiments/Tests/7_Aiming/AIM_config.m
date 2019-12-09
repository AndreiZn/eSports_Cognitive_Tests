function [CFG] = AIM_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Aiming';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.time_timeout = 10; % in seconds
CFG.tests{test_idx}.num_trials = 30;
CFG.tests{test_idx}.radius_target = 80 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.length_cursor = 10 * CFG.general.ratio_pixel;

CFG.tests{test_idx}.test_instructions = ...
    {'Указания: используйте ЛКМ, чтобы кликнуть на круги как можно ближе к их центру.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: click at the center of the targets.', 'Click to start the experiment.'};