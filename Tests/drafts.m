drafts:
As long as raw input is enabled (and it really should be) then the windows mouse settings 
don't apply ingame since the mouse input is grabbed directly from the driver bypassing t
he windows mouse API (hence raw input). Also the windows mouse setting is nothing more 
than a multiplier and only 6 gives 1:1 movement so that's why you shouldn't use anything 
but 6 and instead convert your sensitivity to match what it would be on say 5/change your DPI. 
The windows mouse speed setting is only meant as a last resort if you for example had a cheap 
mouse with no way to adjust the DPI.

Here are the multipliers:

1/11		0.0625
2/11		0.0125
3/11		0.25
4/11		0.5
5/11		0.75
6/11		1
7/11		1.5
8/11		2
9/11		2.5
10/11		3
11/11		3.5

%% RTM
output_name = [dir_prefix experiment_name '_' sub_id '.csv'];
% % Check if csv file exists
% if ~exist(output_name)
%     headers = {'Subject_ID','Trial_Number','Reaction_Time','X_pos','Y_pos','Date','Time'};
%     entry = cell(1, size(headers, 2));
%     table_output = cell2table(entry);
%     table_output.Properties.VariableNames = headers;
%     writetable(table_output, output_name);
%     % xlswrite(output_name, output_items);
% end
% opts = detectImportOptions(output_name);
% opts = setvartype(opts, {'Subject_ID', 'Date', 'Time'}, 'string');
% table_existing = readtable(output_name, opts);


current_date = [datestr(now, 10) datestr(now, 5) datestr(now, 7)];
new_entry = {sub_id counter_trial time_reaction object_x object_y current_date datestr(now, 13)};
table_existing = [table_existing; new_entry];
% output_items = [output_items; new_entry];

%writetable(table_existing, output_name);


CFG.RTM_rand.run_test      1, ...     % 1_2. Simple Reaction Time (Mouse, Random position of circles)
CFG.RTK.run_test          0, ...     % 2_1. Simple Reaction Time (Keyboard)
CFG.RTK_rand.run_test     0, ...     % 2_2. Simple Reaction Time (Keyboard, Random position of circles)
CFG.RTD.run_test           0, ...     % 4. Reaction Time with Decision
CFG.KR.run_test            0, ...     % 5. Keys Reaction
CFG.KMC.run_test           0, ...     % 6. Keyboard-Mouse coordination
CFG.AIM.run_test           0, ...     % 6. Aiming
CFG.MC.run_test            0, ...     % 7. Mouse Clicking
CFG.OT.run_test            0, ...     % 8. Optimal Trajectory
CFG.VS.run_test            0, ...     % 9. Visual Search with Time Limits
CFG.EB.run_test           0, ...     % 10.Expanding Ball
CFG.MEM.run_test          0, ...     % 11.Memory Test
CFG.MOT.run_test           0, ...     % 12.Multi-Object Tracking
CFG.REC.run_test


function [DATA] = RT_prepare_DATA_var(CFG, DATA, test_idx)

DATA_test = DATA.tests{test_idx};
DATA_test.num_trials = CFG.tests{test_idx}.num_max_trial;

DATA_test.reaction_time = zeros(DATA_test.num_trials, 1); % reaction time in ms
DATA_test.target_pos = zeros(DATA_test.num_trials, 2); % position of targets
DATA_test.time_target_appearance = zeros(DATA_test.num_trials, 1); 
DATA_test.time_click = zeros(DATA_test.num_trials, 1); 
DATA_test.time = cell(DATA_test.num_trials, 1); % current date and time
DATA_test.which_button = zeros(DATA_test.num_trials, 1); % clicked by left or right mouse button
