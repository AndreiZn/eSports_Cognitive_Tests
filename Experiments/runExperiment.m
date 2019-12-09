addpath(genpath(pwd));
CFG = struct();
DATA = struct();
%% Test flags
CFG.general.collect_data =  0;      % 0: Debug, 1: Data Collection
CFG.general.flags = ...
    [0, ...    % 1. Simple Reaction Time (Mouse)
    0, ...     % 2. Simple Reaction Time (Mouse, Random position of circles)
    0, ...     % 3. Simple Reaction Time (Keyboard)
    0, ...     % 4. Simple Reaction Time (Keyboard, Random position of circles)
    0, ...     % 5. Reaction Time with Decision
    0, ...     % 6. Reaction Time with Decision, Random position of circles
    0, ...     % 7. Keys Reaction
    0, ...     % 8. Keyboard-Mouse coordination
    0, ...     % 9. Mouse Tracking
    0, ...     % 10. Aiming
    0, ...     % 11. Optimal Trajectory
    0, ...     % 12. Visual Search with Time Limits
    0, ...     % 13. Expanding Ball 1 (Target Constant, Speed Constant)
    0, ...     % 14. Expanding Ball 2 (Target Constant, Speed Not Constant)
    0, ...     % 15. Expanding Ball 3 (Target not constant, speed not constant)
    0, ...     % 16. Expanding Ball 4 (Target beats, speed not constant)
    1, ...     % 17. Memory Test
    1, ...     % 18. Multi-object tracking
    0];        % 19. Recoil
short_names = {'RTM', 'RTM_rand', 'RTK', 'RTK_rand', 'RTD', 'RTD_rand', 'KR', ...
    'KMC', 'MT', 'AIM', 'OT', 'VS', 'EB1', 'EB2', 'EB3', 'EB4', 'MEM', 'MOT', 'REC'};
if numel(short_names) ~= numel(CFG.general.flags)
    errordlg('Check correspondence between short_names and flags')
else
    if ~CFG.general.collect_data
        warndlg('Are you sure that data for this session should not be saved?')
    end
    CFG.general.short_names = short_names;
    CFG.general.available_num_of_tests = numel(CFG.general.flags);
    CFG.tests = cell(CFG.general.available_num_of_tests, 1);
    DATA.tests = cell(CFG.general.available_num_of_tests, 1);
    for test_idx = 1:CFG.general.available_num_of_tests
        CFG.tests{test_idx}.test_name = short_names{test_idx};
        DATA.tests{test_idx}.test_name = short_names{test_idx};
    end
end
%% Language selection
[CFG] = Language_selection(CFG);

if CFG.general.language ~= 1 && CFG.general.language ~= 2
    errordlg('Выбранный язык должен быть 1 или 2/Selected language should be 1 or 2')
else
    %% Login prompt and root folder selection
    [CFG] = Login_rootfolder_prompt(CFG);
    cd(CFG.general.root_folder)
    %% Get physical size of the screen
    [CFG] = Enter_screen_size(CFG);
    %% Create Data Folder
    [CFG] = Create_data_folder(CFG);
    %% PsychDefaultSetup + Keyboard, color and other setups
    [CFG] = Pretest_setup(CFG);
    %% DATA variable set-up
    [DATA] = DATA_var_setup(CFG, DATA);
    %% Open Window, text font
    [CFG] = Open_window(CFG);
    %% Run Tests
    [CFG, DATA] = CompleteTests(CFG, DATA);
    %% Save Data
    save([CFG.general.data_folder_name, 'CFG.mat'], 'CFG')
    save([CFG.general.data_folder_name, 'DATA.mat'], 'DATA')
    Screen('CloseAll')
end

% add date and time of recording to csv
% Save several outputs in csv
% Save output by blocks: main_fields, all_fields, shooting_field
% Run BatchRun from MATLAB?
% write function that combines several DATA files
% Improve KR (color + several lines)
% Optimality in OT
% add testing trials (CFG-train-config)
% add karaoke test 
% Sens raw_input