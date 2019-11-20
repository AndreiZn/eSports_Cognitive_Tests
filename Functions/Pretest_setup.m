function [CFG] = Pretest_setup(CFG)

%% Psychtoolbox Default Setup
% random seed
rand('state', sum(100*clock));
% some screen setups for Psychtoolbox 3
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
%% Keyboard Setups
KbName('UnifyKeyNames');
CFG.general.LeftArrowKey = KbName('LeftArrow'); CFG.general.RightArrowKey = KbName('RightArrow');
CFG.general.spaceKey = KbName('space'); CFG.general.escKey = KbName('Escape');
CFG.general.key_w = KbName('W'); CFG.general.key_s = KbName('S');
CFG.general.key_a = KbName('A'); CFG.general.key_d = KbName('D');
CFG.general.key_shift = KbName('shift'); CFG.general.key_ctrl = KbName('control');
%% Color setups
CFG.general.white = [255 255 255]; 
CFG.general.black = [0 0 0];
CFG.general.red = [255, 0.0, 0.0];
CFG.general.gray = [127 127 127]; 
CFG.general.blue = [76 76 204]; %58 95 205
CFG.general.green = [50 180 50];
CFG.general.royalred = [204 76 76]; %58 95 205
CFG.general.yellow = [240 240 40];
CFG.general.orange = [255 120 0];
CFG.general.brown = [120 80 40];
CFG.general.purple = [175 30 200];
CFG.general.bgcolor = CFG.general.black; 
CFG.general.textcolor = CFG.general.white;
%% Other setups
CFG.general.vertical_text_distance = 80; % Distance betwewen lines, when presenting instructions
CFG.general.num_experiment = 0; % number of conducted experiments
CFG.general.default_resolution = [1920 1080];
CFG.general.default_frame_rate = 60; %Hz
CFG.general.CSGO_coef = 0.2764;
CFG.general.sensitivity_skip_factor = 2.5 * CFG.general.CSGO_coef;