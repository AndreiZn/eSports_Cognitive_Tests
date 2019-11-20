function [PP_CFG, PP_DATA] = RTD_postprocessing_multi(PP_CFG, PP_DATA, CFG, DATA, test_idx)

[PP_CFG, PP_DATA] = RT_postprocessing_core_multi(PP_CFG, PP_DATA, CFG, DATA, test_idx);