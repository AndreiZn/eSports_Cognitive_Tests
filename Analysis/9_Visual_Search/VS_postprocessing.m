function [PP_CFG, PP_DATA] = VS_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA.tests{test_idx}.test_name;

if ~isfield(DATA.tests{test_idx}, 'final_score')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    PP_DATA.tests{test_idx}.final_score = DATA.tests{test_idx}.final_score;
    
    correct_ans = DATA.tests{test_idx}.correct_ans;
    answered_correct = DATA.tests{test_idx}.answered_correct;
    r_t = DATA.tests{test_idx}.time_reaction;
    
    rt_L = r_t(logical( (correct_ans == 1).* (answered_correct == 1)));
    PP_DATA.tests{test_idx}.mean_rt_L_present_ans_coorect = mean(rt_L);
    PP_DATA.tests{test_idx}.median_rt_L_present_ans_coorect = median(rt_L);
    PP_DATA.tests{test_idx}.std_rt_L_present_ans_coorect = std(rt_L);
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [num2str(round(mean(rt_L), 2)), '+-', num2str(round(std(rt_L),2))];
end