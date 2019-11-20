function [PP_CFG, PP_DATA] = MT_postprocessing_multi_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

%PP_CFG.tests{test_idx}.lower_timelasted_border = 1.5; % seconds

PP_CFG.tests{test_idx}.key_factor_name = 'MT_Normalized_error_prctg';