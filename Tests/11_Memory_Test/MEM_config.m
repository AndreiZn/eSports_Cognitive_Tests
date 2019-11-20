function [CFG] = MEM_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Memory_Test';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.num_min_target = 3;
CFG.tests{test_idx}.num_max_target = 6;
CFG.tests{test_idx}.num_trials_per_level = 3;
CFG.tests{test_idx}.grid_size  = 9;
CFG.tests{test_idx}.grid_dim = 80 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.grid_display_time = 2; %sec
CFG.tests{test_idx}.line_width = 5 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.target_color = CFG.general.blue;
CFG.tests{test_idx}.grid_color = CFG.general.gray;
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Запомните расположение синих квадратов, укажите их расположение ЛКМ.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: Remember and click on the blue grids.', 'Click to start the experiment.'};