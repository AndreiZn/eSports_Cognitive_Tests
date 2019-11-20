function [CFG] = OT_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Optimal_Trajectory';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.num_targets = 5;
CFG.tests{test_idx}.num_trials  = 20;
CFG.tests{test_idx}.length_cursor = 10 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.radius_circle = 80 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Кликните на несколько кругов как можно быстрее и ближе к их центру.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: Click on all targets as fast as possible.', 'Click to start the experiment.'};