function [CFG] = MT_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Mouse_Tracking';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.experiment_time = 10; % in seconds
CFG.tests{test_idx}.num_trials = 10;
CFG.tests{test_idx}.time_step_target_changes_speed = 2.5;
CFG.tests{test_idx}.speed_coef_x = 28 * CFG.general.ratio_pixel/CFG.general.ratio_frame_rate;
CFG.tests{test_idx}.speed_coef_y = 28 * CFG.general.ratio_pixel/CFG.general.ratio_frame_rate;
CFG.tests{test_idx}.target_radius = 100 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.cursor_length = 10 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: используйте мышку, чтобы повторить движение цели по экрану.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: use your mouse to track the target.', 'Click to start the experiment.'};