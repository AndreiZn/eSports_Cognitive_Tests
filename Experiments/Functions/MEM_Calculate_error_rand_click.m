function [mean_random_error, std_random_error] = MEM_Calculate_error_rand_click(grid_size_trial, grid_pos_trial, num_clicks_trial)

default_num_repetitions = 100;
error = zeros(default_num_repetitions, 1);
for rep_idx = 1:default_num_repetitions
    click_pos_rand = round(rand(num_clicks_trial, 2)*grid_size_trial+1);
    [error(rep_idx, 1)] = MEM_MOT_Calculate_error(click_pos_rand, grid_pos_trial); % error in num_cell units
end

mean_random_error = mean(error);
std_random_error = std(error);