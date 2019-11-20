function [PP_CFG, PP_DATA] = EB3_postprocessing_multi_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.key_factor_name = 'EB3_Error_npix';