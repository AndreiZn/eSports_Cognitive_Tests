function [DATA] = DATA_var_setup(CFG, DATA)

DATA.general.sub_id = CFG.general.sub_id;
DATA.general.date = datestr(now, 'yyyymmdd');
DATA.general.time = datestr(now, 'HH:MM:SS');