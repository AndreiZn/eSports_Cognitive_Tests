function [PP_CFG, PP_DATA] = REC_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = CFG.general.short_names{test_idx};

if ~isfield(DATA.tests{test_idx}, 'num_bursts')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    num_bursts = DATA.tests{test_idx}.num_bursts;
    shots_used = DATA.tests{test_idx}.shots_used;
    shots_to_kill = DATA.tests{test_idx}.shots_to_kill;
    
    PP_DATA.tests{test_idx}.mean_shots_to_kill = mean(shots_to_kill);
    PP_DATA.tests{test_idx}.mean_shots_to_kill = mean(shots_used);
    
    PP_DATA.tests{test_idx}.mean_num_bursts = mean(num_bursts);
    PP_DATA.tests{test_idx}.median_num_bursts = median(num_bursts);
    PP_DATA.tests{test_idx}.std_num_bursts = std(num_bursts);
    PP_DATA.tests{test_idx}.normalized_mean_num_bursts = mean(num_bursts)/mean(shots_to_kill);
    PP_DATA.tests{test_idx}.normalized_median_num_bursts = median(num_bursts)/mean(shots_to_kill);
    PP_DATA.tests{test_idx}.normalized_std_num_bursts = std(num_bursts)/mean(shots_to_kill);
    
    PP_DATA.tests{test_idx}.accuracy_percentage = 100*shots_to_kill./shots_used;
    PP_DATA.tests{test_idx}.mean_accuracy_percentage = mean(PP_DATA.tests{test_idx}.accuracy_percentage);
    PP_DATA.tests{test_idx}.median_accuracy_percentage = median(PP_DATA.tests{test_idx}.accuracy_percentage);
    PP_DATA.tests{test_idx}.std_accuracy_percentage = std(PP_DATA.tests{test_idx}.accuracy_percentage);
    
    recoil_coef = PP_DATA.tests{test_idx}.mean_accuracy_percentage / PP_DATA.tests{test_idx}.normalized_mean_num_bursts;
    max_recoil_coef = 100 / (1 / mean(shots_to_kill));
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = num2str(round(100 * recoil_coef / max_recoil_coef));
end