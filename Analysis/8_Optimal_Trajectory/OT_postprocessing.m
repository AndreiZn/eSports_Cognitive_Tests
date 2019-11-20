function [PP_CFG, PP_DATA] = OT_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

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
    Optimality = [];
    for trial_idx = 1:num_trials
        
        coef_trial = [];
        
        target_pos = DATA.tests{test_idx}.target_pos;
        target_pos_trial = target_pos{trial_idx, :};
        mouse_traj_trial = DATA.tests{test_idx}.mouse_trajectory{trial_idx, :};
        mouse_pos_0 = mouse_traj_trial(1, :);
        
        [OptimalTour_trial, Optimal_length_trial] = Find_Optimal_Trajectory(mouse_pos_0, target_pos_trial);
        % get length_traj_mouse
        length_traj_mouse_trial = sum(sum(diff(mouse_traj_trial) .^2, 2) .^ 0.5);
        Optimality_trial = Optimal_length_trial / length_traj_mouse_trial;
        Optimality = [Optimality, Optimality_trial];
        
        reaction_time_click_trial = 1000*DATA.tests{test_idx}.reaction_time_click{trial_idx, :};
        reaction_time_click_trial = [0; reaction_time_click_trial];
        reaction_time_click_trial = diff(reaction_time_click_trial);
        reaction_time_click_trial(1) = reaction_time_click_trial(1) - time_reaction_average;
        
        pos_click_trial = DATA.tests{test_idx}.pos_click{trial_idx};
        pos_click_trial = [mouse_pos_0; pos_click_trial];
        click_distance_trial = sum(diff(pos_click_trial) .^2, 2) .^0.5;
        
        for idx=1:numel(reaction_time_click_trial)
            coef_click = click_distance_trial(idx)/reaction_time_click_trial(idx);
            coef_click = coef_click/CFG.general.ratio_pixel;
            coef_trial = [coef_trial, coef_click];
        end
        
        coef = [coef; coef_trial];
    end
    
    PP_DATA.tests{test_idx}.aiming_coef = coef;
    PP_DATA.tests{test_idx}.mean_aiming_coef = mean(coef(:));
    PP_DATA.tests{test_idx}.median_aiming_coef = median(coef(:));
    PP_DATA.tests{test_idx}.std_aiming_coef = std(coef(:));
    PP_DATA.tests{test_idx}.trajectory_optimality = Optimality;
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    %PP_DATA.tests{test_idx}.key_factor = [num2str(round(mean(Optimality), 2)*100), '%'];
    PP_DATA.tests{test_idx}.key_factor = [num2str(round(mean(coef(:)), 2)), '+-', num2str(round(std(coef(:)),2))];
end