function [PP_CFG, PP_DATA] = AIM_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA.tests{test_idx}.test_name;

if ~isfield(DATA.tests{test_idx}, 'num_trials')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    time_reaction_average = PP_CFG.tests{test_idx}.default_reaction_time;
    PP_DATA.tests{test_idx}.default_reaction_time_used = 1;
    
    RTM_rand_idx = 0;
    for idx = 1:numel(PP_CFG.general.tests_to_postprocess_names)
        if strcmp(PP_CFG.general.tests_to_postprocess_names{1, idx}, 'RTM_rand')
            RTM_rand_idx = idx;
            break;
        end
    end
    
    if RTM_rand_idx ~= 0
        if isfield(PP_DATA.tests{RTM_rand_idx}, 'mean_rt')
            time_reaction_average = PP_DATA.tests{RTM_rand_idx}.mean_rt;
            PP_DATA.tests{test_idx}.default_reaction_time_used = 0;
        end
    end
    num_trials = DATA.tests{test_idx}.num_trials;
    
    coef = [];
    for trial_idx = 1:num_trials
        target_pos = DATA.tests{test_idx}.target_pos;
        target_pos_trial = target_pos(trial_idx, :);
        
        mouse_traj_trial = DATA.tests{test_idx}.mouse_trajectory{trial_idx};
        
        length_traj_optimal = (sum((target_pos_trial - mouse_traj_trial(1,:)) .^ 2)) ^ 0.5;
        % get length_traj_mouse
        length_traj_mouse = sum(sum(diff(mouse_traj_trial) .^2, 2) .^ 0.5);
        %ratio_traj_mouse_optimal = length_traj_mouse / length_traj_optimal;
        
        time_reaction_aiming = 1000*DATA.tests{test_idx}.time_reaction;
        time_reaction_aiming_trial = time_reaction_aiming(trial_idx);
        coef_trial = length_traj_optimal / (time_reaction_aiming_trial - time_reaction_average);
        coef_trial = coef_trial/CFG.general.ratio_pixel;
        coef = [coef, coef_trial];
    end
    
    PP_DATA.tests{test_idx}.aiming_coef = coef;
    PP_DATA.tests{test_idx}.mean_aiming_coef = mean(coef);
    PP_DATA.tests{test_idx}.median_aiming_coef = median(coef);
    PP_DATA.tests{test_idx}.std_aiming_coef = std(coef);
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [num2str(round(PP_DATA.tests{test_idx}.mean_aiming_coef, 2)), '+-', num2str(round(PP_DATA.tests{test_idx}.std_aiming_coef, 2))];
end