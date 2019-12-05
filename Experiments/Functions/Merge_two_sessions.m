[filename_cfg_1, pathname_cfg_1, ~] = uigetfile();
[filename_data_1, pathname_data_1, ~] = uigetfile();
[filename_cfg_2, pathname_cfg_2, ~] = uigetfile();
[filename_data_2, pathname_data_2, ~] = uigetfile();

f_data_1 = fullfile(pathname_data_1, filename_data_1); DATA_1 = load(f_data_1); DATA_1 = DATA_1.DATA;
f_cfg_1 = fullfile(pathname_cfg_1, filename_cfg_1); CFG_1 = load(f_cfg_1); CFG_1 = CFG_1.CFG;
f_data_2 = fullfile(pathname_data_2, filename_data_2); DATA_2 = load(f_data_2); DATA_2 = DATA_2.DATA;
f_cfg_2 = fullfile(pathname_cfg_2, filename_cfg_2); CFG_2 = load(f_cfg_2); CFG_2 = CFG_2.CFG;

flag = 1;
idx = 1;
while flag
   s = DATA_1.tests{idx};
   names = fieldnames(s,'-full');
   if numel(names) < 2
       flag = 0;
   end
   idx = idx + 1;
end

DATA = DATA_1;
DATA.tests(idx-1:end) = DATA_2.tests(idx-1:end);

CFG = CFG_1;
CFG.tests(idx-1:end) = CFG_2.tests(idx-1:end);

uisave('CFG')
uisave('DATA')