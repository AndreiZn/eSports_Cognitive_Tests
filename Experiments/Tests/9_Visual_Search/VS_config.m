function [CFG] = VS_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'Visual_Search';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.grid_size = 19;
CFG.tests{test_idx}.truncate_prob = 0.5; % discard those greater than this prob
CFG.tests{test_idx}.grid_dim = 25 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.offset_x = 0;
CFG.tests{test_idx}.offset_y = 0;
CFG.tests{test_idx}.text_size = 20 * CFG.general.ratio_pixel;  % 20 35
CFG.tests{test_idx}.time_limit = 60; % time limit in seconds
CFG.tests{test_idx}.flag_show_score = 1;

CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Определите есть ли буква L на экране.', 'Да = Левый клик мыши. Нет = Правый клик.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: Decide whether letter L exist.', 'Yes = Left Click, No = Right Click.', 'Click to start the experiment.'};