function [PP_CFG, PP_DATA] = MT_postprocessing_multi(PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA_array(1).tests{test_idx}.test_name;

num_data = size(DATA_array, 2);
flag_all_data_valid = true;
figure_count = 0;
DATA_array2 = [];
for idx = 1:num_data
    if ~isfield(DATA_array(idx).tests{test_idx}, 'num_trials')
        disp(['invalid data in test no. ', num2str(test_idx), ' data no. ' , num2str(idx)]);
    else
        DATA_array2 = [DATA_array2, DATA_array(idx)];
    end
end
DATA_array = DATA_array2;
num_data = length(DATA_array);
disp([num2str(num_data), ' data analyzed.'])

if ~flag_all_data_valid
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    DATA_pro = [];
    DATA_semi = [];
    DATA_non = [];
    DATA_pro_concat = [];
    DATA_semi_concat = [];
    DATA_non_concat = [];

    % categorize data into different groups
    for idx = 1:num_data
        DATA = DATA_array(idx);
        sub_id = str2num(DATA.general.sub_id);

        if sub_id < 1000
            DATA_pro = [DATA_pro; DATA];
        elseif sub_id < 2000
            DATA_semi = [DATA_semi; DATA];
        else
            DATA_non = [DATA_non; DATA];
        end
    end

    error_track_pro = [];
    error_track_non = [];
    % concatenate data of each group into one column
    for idx = 1:size(DATA_pro, 1)
        num_trials = DATA_pro(idx).tests{test_idx}.num_trials;

        for i = 1:num_trials
            traj_mouse = DATA_pro(idx).tests{test_idx}.mouse_trajectory{i};
            traj_target= DATA_pro(idx).tests{test_idx}.target_pos{i};
            error_track = sum(sqrt(sum((traj_mouse - traj_target).^2, 2)));
            error_track = error_track / size(traj_mouse, 1);
            error_track_pro = [error_track_pro; error_track];
        end
    end

    for idx = 1:size(DATA_non, 1)
        num_trials = DATA_non(idx).tests{test_idx}.num_trials;

        for i = 1:num_trials
            traj_mouse = DATA_non(idx).tests{test_idx}.mouse_trajectory{i};
            traj_target= DATA_non(idx).tests{test_idx}.target_pos{i};
            error_track = sum(sqrt(sum((traj_mouse - traj_target).^2, 2)));
            error_track = error_track / size(traj_mouse, 1);
            error_track_non = [error_track_non; error_track];
        end
    end
    
    mean_error_track_pro = mean(error_track_pro);
    mean_error_track_non = mean(error_track_non);
    
    figure_count = figure_count + 1;
	f = figure(figure_count);
    bar(1, mean_error_track_pro);
    grid on;
	hold on;
    bar(3, mean_error_track_non);
    
    set(gca,'XTickLabel','');
    ylim_max = max([mean_error_track_pro; mean_error_track_non]) + 10;
	ylim([0, ylim_max]);
	xlabel(' ');
	ylabel('Average Mouse Tracking Error [pixel]');
	title('Mouse Tracking Test');
	legend('Professional','Non-Professional','location','best')
    
    PP_DATA.tests{test_idx}.mean_normalized_error = mean(error_track_pro);
    PP_DATA.tests{test_idx}.median_normalized_error = median(error_track_pro);
    PP_DATA.tests{test_idx}.std_normalized_error = std(error_track_pro);
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
end