function [PP_CFG, PP_DATA] = KR_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA.tests{test_idx}.test_name;

if ~isfield(DATA.tests{test_idx}, 'reaction_time')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    PP_DATA.tests{test_idx}.total_time = sum(DATA.tests{test_idx}.reaction_time);
    correct = DATA.tests{test_idx}.num_trials - sum(DATA.tests{test_idx}.num_mistakes);
    KR_score = correct*1000/PP_DATA.tests{test_idx}.total_time;
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = num2str(round(KR_score, 1));
end