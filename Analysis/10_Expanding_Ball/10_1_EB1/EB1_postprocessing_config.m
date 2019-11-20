function [PP_CFG, PP_DATA] = EB1_postprocessing_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.key_factor_name = 'EB1_Error_npix';