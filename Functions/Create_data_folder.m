function [CFG] = Create_data_folder(CFG)

% Debug: create a folder <root>\Recorded_Data\DebugData
% Data_collection: create a folder <root>\Recorded_Data\<date>_session_n

data_subfolder = 'Recorded_Data\';

if CFG.general.collect_data
    
    date = datestr(now, 'yyyymmdd'); % get current date as a string
    data_folder_name = ['C:\toolbox\', data_subfolder date '\'];
    
    if ~exist(data_folder_name, 'dir')
        mkdir(data_folder_name);
    end
    
    listing = dir(data_folder_name); % get the lisiting of existing folders
    listing = listing(3:end); % delete first two folders from the list ('.\', '..\')

    folder_exists = 0;
    % check if some folder with CFG.general.sub_id
    for idx=1:size(listing,1)
        if strfind(listing(idx).name, CFG.general.sub_id) % some folder for current date already exists
            folder_exists = 1;
            existing_folder_name = listing(idx).name;
            existing_folder_idx = str2double(existing_folder_name(end-2:end)); %  last 3 symbols identify number of the session
        end
    end
    
    if ~folder_exists
        session = 1;
    else
        session = existing_folder_idx + 1;
    end
    
    data_folder_name = [data_folder_name 'sub' CFG.general.sub_id '_session_' num2str(session,'%03.f') '\' ];
    mkdir(data_folder_name);
    CFG.general.data_folder_name = data_folder_name;
    
else
    data_folder_name = ['C:\toolbox\' ...
        'DebugData\'];
    if ~exist(data_folder_name, 'dir')
        mkdir(data_folder_name);
    end
    CFG.general.data_folder_name = data_folder_name;
end
