function [PP_CFG, PP_DATA] = AIM_postprocessing_config(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_CFG.tests{test_idx}.default_reaction_time = 250; % mseconds

PP_CFG.tests{test_idx}.key_factor_name = 'AIM_speed_npix_per_ms';