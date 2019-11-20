function [PP_CFG, PP_DATA] = EB2_postprocessing_multi(PP_CFG, PP_DATA, CFG, DATA, test_idx)

[PP_CFG, PP_DATA] = EB_postprocessing_core_multi(PP_CFG, PP_DATA, CFG, DATA, test_idx);