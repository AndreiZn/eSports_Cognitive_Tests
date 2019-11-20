function [CFG_array, DATA_array] = Combine_CFG_DATA_to_arrays(ignore_dates, ignore_IDs, CFG_array, DATA_array)

answer = questdlg('Select files automatically?', ...
	'Select files for analysis', ...
	'Yes','No','Yes');
% Handle response
switch answer
    case 'Yes'
        answer = questdlg('Please select data folder', ...
            'Select data folder', ...
            'Ok','Cancel','Ok');
        if strcmp(answer, 'Cancel')
            return;
        else
            data_folder = uigetdir('C:\toolbox\Recorded_Data\');
            listing = dir(data_folder);
            listing = listing(3:end);
            
            for dir_idx = 1:size(listing,1)
                
                dir_struct = listing(dir_idx);
                is_dir = dir_struct.isdir;
                dir_name = dir_struct.name;
                dir_path = [dir_struct.folder, '\', dir_name, '\'];
                
                if is_dir && ~any(strcmp(ignore_dates, dir_name))
                    
                    sub_dir_listing = dir(dir_path);
                    sub_dir_listing = sub_dir_listing(3:end);
                    
                    for sub_dir_idx = 1:size(sub_dir_listing, 1)
                        
                        sub_dir_struct = sub_dir_listing(sub_dir_idx);
                        is_sub_dir = sub_dir_struct.isdir;
                        sub_dir_name = sub_dir_struct.name;
                        ignore_sub = any(strcmp(ignore_IDs, sub_dir_name(4:7)));
                        sub_dir_path = [sub_dir_struct.folder, '\', sub_dir_name, '\'];
                        
                        if is_sub_dir && ~ignore_sub
                            
                            sub_files = dir(sub_dir_path);
                            sub_files = sub_files(3:end);
                            CFG = []; DATA = [];
                            
                            for sub_file_idx = 1:size(sub_files)
                                
                                sub_file_struct = sub_files(sub_file_idx);
                                is_file = ~sub_file_struct.isdir;
                                sub_file_name = sub_file_struct.name;
                                sub_file_path = [sub_file_struct.folder, '\', sub_file_name];

                                if is_file 
                                    switch sub_file_name
                                        case 'CFG.mat'
                                            CFG = load(sub_file_path);
                                            CFG = CFG.CFG;
                                        case 'DATA.mat'
                                            DATA = load(sub_file_path);
                                            DATA = DATA.DATA;
                                    end
                                end
                                
                            end
                            
                            if ~isempty(CFG) && ~isempty(DATA)
                                DATA_array = [DATA_array, DATA];
                                CFG_array = [CFG_array, CFG];
                            end
                            
                        end
                    end
                end
            end
        end
    case 'No'
        while 1
            [filename, root] = uigetfile('*.mat', 'Select file to be analyzed', 'C:\toolbox\Recorded_Data\');
            if filename == 0
                break
            else
                filename_DATA = [root, filename];
                filename_CFG = [root, 'CFG.mat'];
                DATA = load(filename_DATA); DATA = DATA.DATA;
                CFG = load(filename_CFG); CFG = CFG.CFG;
                DATA_array = [DATA_array, DATA];
                CFG_array = [CFG_array, CFG];
            end
        end
end