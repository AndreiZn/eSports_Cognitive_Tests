function [PP_CFG, PP_DATA] = MOT_postprocessing_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.key_factor_name = 'MOT_Error_npix';