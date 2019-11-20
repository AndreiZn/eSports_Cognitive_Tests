function [PP_CFG, PP_DATA] = EB4_postprocessing_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.key_factor_name = 'EB4_Error_npix';