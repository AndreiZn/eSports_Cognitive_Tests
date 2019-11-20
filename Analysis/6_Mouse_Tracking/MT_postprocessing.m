function [PP_CFG, PP_DATA] = MT_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA.tests{test_idx}.test_name;

if ~isfield(DATA.tests{test_idx}, 'num_trials')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    num_trials = DATA.tests{test_idx}.num_trials;
    normalized_error = zeros(1, num_trials);
    
    for trial_idx = 1:num_trials
        mouse_pos = DATA.tests{test_idx}.mouse_trajectory{trial_idx};
        target_pos = DATA.tests{test_idx}.target_pos{trial_idx};
        error = sum(sqrt(sum((mouse_pos - target_pos).^2, 2)));
        len_traj = sum(sqrt(sum(target_pos.^2, 2)));
        normalized_error(1,trial_idx) = error/len_traj;
    end
    
    PP_DATA.tests{test_idx}.mean_normalized_error = mean(normalized_error);
    PP_DATA.tests{test_idx}.median_normalized_error = median(normalized_error);
    PP_DATA.tests{test_idx}.std_normalized_error = std(normalized_error);
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [num2str(100*round(mean(normalized_error),3)), '+-', num2str(100*round(std(normalized_error),3))];
end