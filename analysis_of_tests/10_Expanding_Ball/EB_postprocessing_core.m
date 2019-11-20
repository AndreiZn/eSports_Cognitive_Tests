function [PP_CFG, PP_DATA] = EB_postprocessing_core(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA.tests{test_idx}.test_name;

if ~isfield(DATA.tests{test_idx}, 'error_radius')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    error_radius = DATA.tests{test_idx}.error_radius;
    PP_DATA.tests{test_idx}.mean_error_radius = mean(error_radius/CFG.general.ratio_pixel);
    PP_DATA.tests{test_idx}.median_error_radius = median(error_radius/CFG.general.ratio_pixel);
    PP_DATA.tests{test_idx}.std_error_radius = std(error_radius/CFG.general.ratio_pixel);
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [num2str(round(PP_DATA.tests{test_idx}.mean_error_radius)), '+-', num2str(round(PP_DATA.tests{test_idx}.std_error_radius))];
end