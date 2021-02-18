function [CFG] = REC_config(CFG, test_idx)

CFG.tests{test_idx}.long_name = 'RecoilControl_Test';
CFG.tests{test_idx}.expected_user_input = 'keyboard';
% Experimental parameters
CFG.tests{test_idx}.im = imread([CFG.general.root_folder, 'Experiments\Auxilary_files\target2.png']);
bullet_trajectory = load([CFG.general.root_folder, 'Experiments\Auxilary_files\AK47_30blts_spray_trajectory.mat']);
CFG.tests{test_idx}.num_repetitions_train = 1;
CFG.tests{test_idx}.num_repetitions_test = 5;
CFG.tests{test_idx}.shots_to_kill_array = [1, 3, 5, 7, 10, 15, 20, 30];
%CFG.tests{test_idx}.shots_to_kill_array = [1, 3, 5];
CFG.tests{test_idx}.cursor_length = 20 * CFG.general.ratio_pixel; 
CFG.tests{test_idx}.CSGO_coef = 0.2764 * CFG.general.ratio_pixel;
CFG.tests{test_idx}.sensitivity_skip_factor = 2.2 * CFG.tests{test_idx}.CSGO_coef;
% trajectory should be spread over 140 pixels vertically (as in the recoil master map)
spread_parameter = 140 * CFG.general.ratio_pixel;
bullet_trajectory = bullet_trajectory.thePoints;
ratio_traj = (max(bullet_trajectory(:,2)) - min(bullet_trajectory(:,2)))/spread_parameter;
CFG.tests{test_idx}.bullet_trajectory = bullet_trajectory/ratio_traj;
CFG.tests{test_idx}.aim_marker_radius = 8 * CFG.general.ratio_pixel;

% target size should be 57pixels (as in the recoil master map)
required_target_size = 57 * CFG.general.ratio_pixel;
ratio_target = size(CFG.tests{test_idx}.im,1)/required_target_size;
target_size = size(CFG.tests{test_idx}.im)/ratio_target;
CFG.tests{test_idx}.target_size = target_size(1:2); %don't use the third dimension
CFG.tests{test_idx}.shots_per_second = 10;