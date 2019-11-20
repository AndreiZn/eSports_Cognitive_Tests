function [CFG] = MOT_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'MultiObject_Tracking';
CFG.tests{test_idx}.expected_user_input = 'mouse';
CFG.tests{test_idx}.time_experiment = 10;        % length of experiment time, in seconds
CFG.tests{test_idx}.num_min_target = 4;         % minimum number of targets to be tracked
CFG.tests{test_idx}.num_max_target = 6;         % maximum number of targets to be tracekd
CFG.tests{test_idx}.num_trials_per_level = 5;         % number of trials for each number of targets.
CFG.tests{test_idx}.speed_coef_x = 3 * CFG.general.ratio_pixel/CFG.general.ratio_frame_rate; % speed coefficient of x
CFG.tests{test_idx}.speed_coef_y = 3 * CFG.general.ratio_pixel/CFG.general.ratio_frame_rate; % speed coefficient of y
CFG.tests{test_idx}.num_total_trials = (CFG.tests{test_idx}.num_max_target - ... 
                                        CFG.tests{test_idx}.num_min_target + 1) * ...
                                        CFG.tests{test_idx}.num_trials_per_level; % number of total trials that should be performed
CFG.tests{test_idx}.radius_circle = 70 * CFG.general.ratio_pixel;   % size of the objects
CFG.tests{test_idx}.target_color = CFG.general.royalred;
CFG.tests{test_idx}.circle_color = CFG.general.blue;
CFG.tests{test_idx}.correct_circle_color = CFG.general.green;
CFG.tests{test_idx}.test_instructions = ...
    {'Указания: Следите глазами за красными кругами (целями).', 'Укажите цели ЛКМ.', 'Нажмите ЛКМ, чтобы начать тест.';...
    'Instruction: Track red targets with your eyes.', 'Click on targets after circles stop.', 'Click to start the experiment.'};