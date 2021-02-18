function [CFG] = Enter_screen_size(CFG)

prompt_login = {'?????? ?????? ?? ??????????? ? ??:'; 'Horizontal screen size, cm:'};
prompt_folder = {'?????? ?????? ?? ????????? ? ??:'; 'Verical screen size, cm:'};
prompt = [prompt_login, prompt_folder];
CFG.general.root_folder = 'C:\toolbox\eSports_Cognitive_Tests\';
defaults = {'52.704', '29.646'};
answer = inputdlg(prompt(CFG.general.language, :), ' ', 2, defaults);
CFG.general.horizontal_size_cm = str2double(answer{1,1}); % get horizontal screen size, cm
CFG.general.vertical_size_cm = str2double(answer{2,1}); % get vertical screen size, cm