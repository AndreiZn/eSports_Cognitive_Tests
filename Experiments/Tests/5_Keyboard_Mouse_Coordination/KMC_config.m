function [CFG] = KMC_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Keyboard_Mouse_Coordination';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.num_trials_per_level = 10; % trials per difficulty level
CFG.tests{test_idx}.num_min_objects = 3;	% minimum number of circles on each side
CFG.tests{test_idx}.num_max_objects = 5;	% maximum number of circles on each side
CFG.tests{test_idx}.speed_coef 	   = 24  * CFG.general.ratio_pixel/CFG.general.ratio_frame_rate;
CFG.tests{test_idx}.sensitivity_kb = 32  * CFG.general.ratio_pixel/CFG.general.ratio_frame_rate;
CFG.tests{test_idx}.radius_circle = 80 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.line_width = 5;
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Используйте клавиши w-a-s-d для контроля левого круга.', 'Используйте мышь для контроля правого круга.', 'Избегайте сооударений с красными кругами и линией посередине.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: use w-a-s-d to control left circle.', 'Use mouse to control right circle.', 'Avoid red circles and middle line.', 'Click to start the experiment.'};