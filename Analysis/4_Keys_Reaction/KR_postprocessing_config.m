function [PP_CFG, PP_DATA] = KR_postprocessing_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.key_factor_name = 'KR_Score_1_per_s';