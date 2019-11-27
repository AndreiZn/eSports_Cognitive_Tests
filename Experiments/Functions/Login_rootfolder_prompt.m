function [CFG] = Login_rootfolder_prompt(CFG)

prompt_login = {'Введите ID-номер тестируемого:'; 'Subject''s ID:'};
prompt_folder = {'Выберите основную папку'; 'Select root folder:'};
prompt = [prompt_login, prompt_folder];
CFG.general.root_folder = 'C:\toolbox\eSports_Cognitive_Tests\';
defaults = {'0000', CFG.general.root_folder};
answer = inputdlg(prompt(CFG.general.language, :), ' ', 2, defaults);
CFG.general.sub_id = answer{1,1}; % get subject id
CFG.general.root_folder = answer{2,1}; % get root folder

% determine participant's group according to range of ID
if str2num(CFG.general.sub_id) > 2000
    CFG.general.sub_group = 'Student';
elseif str2num(CFG.general.sub_id) > 1000
    CFG.general.sub_group = 'Trainee';
else
    CFG.general.sub_group = 'Professional';
end