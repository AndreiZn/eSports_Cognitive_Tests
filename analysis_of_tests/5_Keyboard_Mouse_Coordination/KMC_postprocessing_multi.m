function [PP_CFG, PP_DATA] = KMC_postprocessing_multi(PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA_array(1).tests{test_idx}.test_name;

num_data = size(DATA_array, 2);
flag_all_data_valid = true;
figure_count = 0;
DATA_array2 = [];
for idx = 1:num_data
    if ~isfield(DATA_array(idx).tests{test_idx}, 'time_lasted')
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

    % concatenate data of each group into one column
    for idx = 1:size(DATA_pro, 1)
        num_current_objects = DATA_pro(idx).tests{test_idx}.num_current_objects;
        time_lasted         = DATA_pro(idx).tests{test_idx}.time_lasted;
        flag_collision      = DATA_pro(idx).tests{test_idx}.flag_collision;

        DATA_pro_concat = [DATA_pro_concat; num_current_objects, time_lasted, flag_collision];
    end
    lower_bound = PP_CFG.tests{test_idx}.lower_timelasted_border;
    DATA_pro_concat = DATA_pro_concat(DATA_pro_concat(:, 2) > lower_bound, :);

    for idx = 1:size(DATA_non, 1)
        num_current_objects = DATA_non(idx).tests{test_idx}.num_current_objects;
        time_lasted         = DATA_non(idx).tests{test_idx}.time_lasted;
        flag_collision      = DATA_non(idx).tests{test_idx}.flag_collision;

        DATA_non_concat = [DATA_non_concat; num_current_objects, time_lasted, flag_collision];
    end
    lower_bound = PP_CFG.tests{test_idx}.lower_timelasted_border;
    DATA_non_concat = DATA_non_concat(DATA_non_concat(:, 2) > lower_bound, :);
    
    num_rows_pro = size(DATA_pro_concat, 1);
    num_rows_non = size(DATA_non_concat, 1);

    min_target_number = min(min(DATA_pro_concat(:,1)), min(DATA_non_concat(:,1)));
	max_target_number = max(max(DATA_pro_concat(:,1)), max(DATA_non_concat(:,1)));  
    
    mean_accuracy = [];
	for cur_target_number = min_target_number:max_target_number
		i_level = cur_target_number - min_target_number + 1;
	    focus_entries_pro = DATA_pro_concat(find(DATA_pro_concat(:, 1) == cur_target_number), :);
	    mean_accuracy_pro(i_level, 1) = mean(focus_entries_pro(:, 2)); 
        std_accuracy_pro(i_level, 1)  =  std(focus_entries_pro(:, 2));
        mouse_percentage_pro(i_level, 1) = (sum(focus_entries_pro(:, 3)) / num_rows_pro) * 100;

	    focus_entries_non = DATA_non_concat(find(DATA_non_concat(:, 1) == cur_target_number), :);
	    mean_accuracy_non(i_level, 1) = mean(focus_entries_non(:, 2)); 
        std_accuracy_non(i_level, 1)  =  std(focus_entries_non(:, 2));
        mouse_percentage_non(i_level, 1) = (sum(focus_entries_non(:, 3)) / num_rows_non) * 100;

	    mean_accuracy = [mean_accuracy, mean_accuracy_pro(i_level, 1), mean_accuracy_non(i_level, 1)];
	end

    % box plot
	box_data         = [DATA_pro_concat(:,2); DATA_non_concat(:,2)];
	group_target_num = [DATA_pro_concat(:,1); DATA_non_concat(:,1)];
	group_category = [ones(num_rows_pro, 1); 2 * ones(num_rows_non, 1)];

    p = (max_target_number - min_target_number) + 1;
    positions = [1:3 * p];
    positions = positions(mod(positions, 3) ~= 0); % positions of boxes
	% positions = [1,2,4,5,7,8]; 

	figure_count = figure_count + 1;
	f = figure(figure_count);
	box_handler = boxplot(box_data, {group_target_num,group_category},'whisker',1,'colorgroup', group_target_num, ...
	             'symbol','.','outliersize',4,'widths',0.6,'positions', positions);

	xlabel('Number of Obstacles');
	ylabel('Time Lasted [s]');
    grid on
    ylim_max = max(box_data) + 2;
	set(gca,'YLim',[0, 36],'gridLineStyle', '-.');
	set(gca,'XLim',[0, 9]);
	set(box_handler,'linewidth',1.2);

	h  = findobj(gca,'Tag','Box');
	mk = findobj(gca,'tag','Outliers'); % Get handles for outlier lines.
	set(mk,'Marker','o'); % Change symbols for all the groups.
	for i = 1:length(h) % some coloring
		if mod(i, 2) == 0
			patch(get(h(i),'XData'),get(h(i),'YData'),'r','FaceAlpha',0.1);
		else
			patch(get(h(i),'XData'),get(h(i),'YData'),'b','FaceAlpha',0.1);
		end
	end
	set(gca,'xtick',[1.5,4.5,7.5,10.5,13.5]) % positions of ticks
	set(gca,'XTickLabel',[min_target_number:max_target_number])
	set(gca,'ytick',0:2:ylim_max) % positions of ticks
	title('Keyboard-Mouse Coordination Test');

	% change the order of legends
	boxes = get(gca, 'Children');
	hold on
 	plot(positions, mean_accuracy,'db');
	legend(boxes([1, 2]), {'Professional', 'Non-Professional'}, 'location','best');

    % percentage of collision by mouse
    figure_count = figure_count + 1;
	f = figure(figure_count);
    bar([min_target_number:max_target_number],[mouse_percentage_pro mouse_percentage_non]);
    grid on;
	hold on;
    set(gca,'XTickLabel',{min_target_number:max_target_number});
    ylim_max = max([mouse_percentage_pro; mouse_percentage_non]) + 5;
	ylim([0, ylim_max]);
	xlabel('Number of Obstacles');
	ylabel('Collision by Mouse [%]');
	title('Keyboard-Mouse Coordination Test');
	legend('Professional','Non-Professional','location','best')


    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
end