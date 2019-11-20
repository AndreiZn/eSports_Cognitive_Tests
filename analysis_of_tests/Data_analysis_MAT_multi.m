%% Select File(s) to be Analyzed

addpath(genpath('../'));
addpath(genpath('C:/toolbox/eSport_Tests'));
DATA_array = [];
CFG_array = [];

ignore_dates = {'20190221'; '20190301'; '20190303'; '20190306'; '20190308'; ...
              '20190313'; '20190314'; '20190321'; '20190322'; '20190325'; ...
              '20190404'};
ignore_IDs = {'0000'};

[CFG_array, DATA_array] = Combine_CFG_DATA_to_arrays(ignore_dates, ignore_IDs, CFG_array, DATA_array);
CFG = CFG_array(1);
%% Analyze file by file

%tests_to_analyze = {'RTM', 'RTM_rand', 'RTK', 'RTK_rand', 'RTD', 'RTD_rand', 'KMC', 'AIM'};
tests_to_analyze = {'RTM', 'RTM_rand', 'RTK', 'RTK_rand', 'RTD', 'RTD_rand', 'KR','KMC', 'MT', 'AIM', ...
                    'OT', 'VS', 'EB1', 'EB2', 'EB3', 'EB4', 'MEM', 'MOT', 'REC'};
%tests_to_analyze = {'RTM', 'RTM_rand', 'RTK', 'RTK_rand', 'RTD', 'RTD_rand'};
num_files = size(CFG_array,2);

% here PP_CFG & PP_DATA are used for an array of selected DATA
PP_CFG = struct(); % PostProcessed Config
PP_CFG.tests = cell(CFG.general.available_num_of_tests, 1);
PP_DATA = struct(); % PostProcessed Data
PP_DATA.tests = cell(CFG.general.available_num_of_tests, 1);
if ~isfield(CFG.general, 'order_of_tests')
    CFG.general.order_of_tests = 1:CFG.general.available_num_of_tests;
end
PP_CFG.general.tests_to_postprocess_names = tests_to_analyze;
PP_CFG.general.tests_to_postprocess = [];
for idx = 1:numel(PP_CFG.general.tests_to_postprocess_names)
    PP_CFG.general.tests_to_postprocess = [PP_CFG.general.tests_to_postprocess, find(strcmp(CFG.general.short_names, PP_CFG.general.tests_to_postprocess_names{idx}))];
end

%% Postprocessing loop
headers = cell(1, numel(tests_to_analyze)+1);
headers{1, 1} = 'Group';

new_entry = cell(1, numel(tests_to_analyze)+1);
entry_column_idx = 1;

for test_idx = CFG.general.order_of_tests
    % if find(PP_CFG.general.tests_to_postprocess == test_idx, 1)
    if test_idx == 12 % only for single test
        entry_column_idx = entry_column_idx + 1;

        % Read test_name
        test_analysis_name = [CFG_array(1).tests{test_idx}.test_name, '_postprocessing_multi'];
        % Use config file
        congif_name = [test_analysis_name, '_config'];

        % Run analysis test_name_analysis
        [PP_CFG, PP_DATA] = feval(congif_name,        PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx);       
        [PP_CFG, PP_DATA] = feval(test_analysis_name, PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx);
        
        headers{entry_column_idx} = PP_DATA.tests{test_idx}.key_factor_name;            

        new_entry{1} = CFG_array(1).general.sub_group;
        new_entry{entry_column_idx} = PP_DATA.tests{test_idx}.key_factor;
    end
end

% if file_idx > 1
%     table_key_factors = [table_key_factors; new_entry];
% else
%     entry = cell(1, size(headers, 2));
%     table_key_factors = cell2table(entry);
%     table_key_factors.Properties.VariableNames = headers;
%     table_key_factors(file_idx, :) = new_entry;
% end

% pause(2);
% [filename, root] = uiputfile('*.csv');
% writetable(table_key_factors, [root, filename]);
