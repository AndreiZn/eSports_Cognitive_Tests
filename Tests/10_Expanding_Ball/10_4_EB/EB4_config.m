function [CFG] = EB4_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = '4-ExpandBall_Tar_Beats_Speed_NCon';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.target_const = 0; 
CFG.tests{test_idx}.circle_speed_const = 0; 
CFG.tests{test_idx}.target_moves = 1;
CFG.tests{test_idx}.target_moving_speed = 8 * CFG.general.ratio_pixel/CFG.general.ratio_frame_rate;
CFG.tests{test_idx}.time_target_move_one_direction = 0.8; % sec
CFG.tests{test_idx}.num_trials = 10; 
CFG.tests{test_idx}.time_max = 7;
CFG.tests{test_idx}.time_redraw = 0.01;
CFG.tests{test_idx}.rtwait = 0.02;
CFG.tests{test_idx}.cursor_length = 10 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.radius_target = 640 * CFG.general.ratio_pixel; % specifies size of circle
CFG.tests{test_idx}.expand_speed = 10 * CFG.general.ratio_pixel; % speed in pixel
CFG.tests{test_idx}.circle_color = CFG.general.royalred;
CFG.tests{test_idx}.target_color = CFG.general.gray;
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Кликните в тот момент, когда расширяющийся круг будет наиболее близко к границе.', 'Смотрите в центр расширяющегося круга.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: click when inner circle is closest to outer circle (4)', 'You should focus on the center of the screen', 'Click to start the experiment.'};