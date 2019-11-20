function [PP_CFG, PP_DATA] = RTK_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

[PP_CFG, PP_DATA] = RT_postprocessing_core(PP_CFG, PP_DATA, CFG, DATA, test_idx);