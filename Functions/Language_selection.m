function [CFG] = Language_selection(CFG)

CFG.general.language = 2; % 1 - Russian; 2 - English
prompt = {'Выберите язык (RU - 1)/Select language (EN - 2):'};
defaults = {num2str(CFG.general.language)};
answer = inputdlg(prompt, ' ', 2, defaults);
CFG.general.language = str2double(answer{:});