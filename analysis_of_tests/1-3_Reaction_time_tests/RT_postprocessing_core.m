function [PP_CFG, PP_DATA] = RT_postprocessing_core(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA.tests{test_idx}.test_name;

if ~isfield(DATA.tests{test_idx}, 'reaction_time')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    rt = DATA.tests{test_idx}.reaction_time;
    rt = rt(rt > PP_CFG.tests{test_idx}.lower_rt_border);
    rt = rt(rt < PP_CFG.tests{test_idx}.upper_rt_border);
    
    PP_DATA.tests{test_idx}.test_name = CFG.general.short_names{test_idx};
    PP_DATA.tests{test_idx}.mean_rt = mean(rt);
    PP_DATA.tests{test_idx}.median_rt = median(rt);
    PP_DATA.tests{test_idx}.std_rt = std(rt);
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [num2str(round(PP_DATA.tests{test_idx}.mean_rt)), '+-', num2str(round(PP_DATA.tests{test_idx}.std_rt))];
end