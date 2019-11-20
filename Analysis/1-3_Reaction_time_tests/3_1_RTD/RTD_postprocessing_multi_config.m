function [PP_CFG, PP_DATA] = RTD_postprocessing_multi_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.lower_rt_border = 150;
PP_CFG.tests{test_idx}.upper_rt_border = 700;

PP_CFG.tests{test_idx}.key_factor_name = 'ReactTime_RedBlue_ms';