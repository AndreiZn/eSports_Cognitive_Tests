function [PP_CFG, PP_DATA] = RTM_postprocessing_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.lower_rt_border = 120;
PP_CFG.tests{test_idx}.upper_rt_border = 500;

PP_CFG.tests{test_idx}.key_factor_name = 'ReactTime_Mouse_ms';