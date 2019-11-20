function [mean_random_error, std_random_error] = MOT_Calculate_error_rand_click(CFG_general, DATA_test, trial_idx, num_clicks_trial)

target_pos_trial = DATA_test.target_final_pos{trial_idx};
if ~isfield(DATA_test, 'all_circles_final_pos') % for older versions of tests
    num_targets = DATA_test.num_target(trial_idx);
    num_objects = num_targets * 2;
    x_rand = round((CFG_general.theRect(3)-1)*rand(num_objects, 1) + 1);
    y_rand = round((CFG_general.theRect(4)-1)*rand(num_objects, 1) + 1);
    all_circles_final_pos = [x_rand y_rand];
    all_circles_final_pos(1:num_targets, :) = target_pos_trial;
else
    all_circles_final_pos = DATA_test.all_circles_final_pos{trial_idx};
    num_objects = size(all_circles_final_pos, 1);
end

default_num_repetitions = 100;
error = zeros(default_num_repetitions, 1);
for rep_idx = 1:default_num_repetitions
    click_pos_rand_idx = randsample(num_objects, num_clicks_trial);
    click_pos_rand = all_circles_final_pos(click_pos_rand_idx, :);
    [error(rep_idx, 1)] = MEM_MOT_Calculate_error(click_pos_rand, target_pos_trial); % error in pixels
end

mean_random_error = mean(error);
std_random_error = std(error);