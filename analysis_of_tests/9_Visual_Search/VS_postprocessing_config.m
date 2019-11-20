function [PP_CFG, PP_DATA] = VS_postprocessing_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.key_factor_name = 'VS_React_time_correct_L_s';