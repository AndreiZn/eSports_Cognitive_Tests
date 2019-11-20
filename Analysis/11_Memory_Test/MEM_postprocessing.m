function [PP_CFG, PP_DATA] = MEM_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA.tests{test_idx}.test_name;

if ~isfield(DATA.tests{test_idx}, 'accuracy')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    accuracy = DATA.tests{test_idx}.accuracy;
    num_trials = size(accuracy, 1);
    mean_random_error = zeros(1, num_trials);
    error_in_cells = zeros(1, num_trials);
    num_target = DATA.tests{test_idx}.current_num_target;
    num_target_unique = unique(num_target);
    grid_size = DATA.tests{test_idx}.grid_size;
    
    for trial_idx = 1:num_trials
        click_pos_trial = DATA.tests{test_idx}.click_pos{trial_idx};
        num_clicks_trial = size(click_pos_trial, 1);
        grid_pos_trial = DATA.tests{test_idx}.grid_pos{trial_idx};
        grid_size_trial = grid_size(trial_idx, 1);
        [mean_random_error(1, trial_idx), ~] = MEM_Calculate_error_rand_click(grid_size_trial, grid_pos_trial, num_clicks_trial);
        [error_in_cells(1, trial_idx)] = MEM_MOT_Calculate_error(click_pos_trial, grid_pos_trial); % error in num_cell units
    end
    PP_DATA.tests{test_idx}.error_in_cells = error_in_cells;
    
    for idx = 1:numel(num_target_unique)
        idx_cur = num_target == num_target_unique(idx);
        accuracy_cur = accuracy(idx_cur);
        mean_random_error_cur = mean_random_error(idx_cur);
        error_in_cells_cur = error_in_cells(idx_cur);
        relative_error = error_in_cells_cur./mean_random_error_cur;
        
        PP_DATA.tests{test_idx}.mean_accuracy_per_level(idx,1) = mean(accuracy_cur);
        PP_DATA.tests{test_idx}.median_accuracy_per_level(idx,1) = median(accuracy_cur);
        PP_DATA.tests{test_idx}.std_accuracy_per_level(idx,1) = std(accuracy_cur);
        
        PP_DATA.tests{test_idx}.mean_error_in_cells(idx,1) = mean(error_in_cells_cur);
        PP_DATA.tests{test_idx}.median_error_in_cells(idx,1) = median(error_in_cells_cur);
        PP_DATA.tests{test_idx}.std_error_in_cells(idx,1) = std(error_in_cells_cur);
        
        PP_DATA.tests{test_idx}.mean_relative_error(idx,1) = mean(relative_error);
        PP_DATA.tests{test_idx}.median_relative_error(idx,1) = median(relative_error);
        PP_DATA.tests{test_idx}.std_relative_error(idx,1) = std(relative_error);
    end

    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [Array_to_str(num_target_unique), '->', Array_to_str(100*round(PP_DATA.tests{test_idx}.mean_relative_error, 3))];
    %PP_DATA.tests{test_idx}.key_factor = [Array_to_str(num_target_unique), '->', Array_to_str(100*round(PP_DATA.tests{test_idx}.mean_accuracy_per_level, 2))];
end