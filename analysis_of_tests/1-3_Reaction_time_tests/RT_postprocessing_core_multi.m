function [PP_CFG, PP_DATA] = RT_postprocessing_core_multi(PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA_array(1).tests{test_idx}.test_name;

num_data = size(DATA_array, 2);
flag_all_data_valid = true;
figure_count = 0;
DATA_array2 = [];
for idx = 1:num_data
    if ~isfield(DATA_array(idx).tests{test_idx}, 'reaction_time')
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
        DATA_pro_concat = [DATA_pro_concat; DATA_pro(idx).tests{test_idx}.reaction_time];
    end

    for idx = 1:size(DATA_semi, 1)
        DATA_semi_concat = [DATA_semi_concat; DATA_semi(idx).tests{test_idx}.reaction_time];
    end

    for idx = 1:size(DATA_non, 1)
        DATA_non_concat = [DATA_non_concat; DATA_non(idx).tests{test_idx}.reaction_time];
    end

    % process the data before calculation
    DATA_pro_concat = DATA_pro_concat(DATA_pro_concat > PP_CFG.tests{test_idx}.lower_rt_border);
    DATA_pro_concat = DATA_pro_concat(DATA_pro_concat < PP_CFG.tests{test_idx}.upper_rt_border);

    DATA_semi_concat = DATA_semi_concat(DATA_semi_concat > PP_CFG.tests{test_idx}.lower_rt_border);
    DATA_semi_concat = DATA_semi_concat(DATA_semi_concat < PP_CFG.tests{test_idx}.upper_rt_border);

    DATA_non_concat = DATA_non_concat(DATA_non_concat > PP_CFG.tests{test_idx}.lower_rt_border);
    DATA_non_concat = DATA_non_concat(DATA_non_concat < PP_CFG.tests{test_idx}.upper_rt_border);

    % box plot
    box_data = [DATA_pro_concat(:,1); DATA_non_concat(:,1)];
	group_category = [ones(length(DATA_pro_concat(:, 1)), 1); 2 * ones(length(DATA_non_concat(:, 1)), 1)];
	positions = [1,2]; % positions of boxes
	mean_reaction_time = [mean(DATA_pro_concat(:,1)), mean(DATA_non_concat(:,1))];

	figure_count = figure_count + 1;
	f = figure(figure_count);
	box_handler = boxplot(box_data, {group_category},'whisker',1,'colorgroup', group_category, ...
	             'symbol','.','outliersize',4,'widths',0.6,'positions', positions);

	h  = findobj(gca,'Tag','Box');
	mk = findobj(gca,'tag','Outliers'); % Get handles for outlier lines.
	set(mk,'Marker','o'); % Change symbols for all the groups.
	set(box_handler,'linewidth',1.2);
	for i = 1:length(h) % some coloring
		if mod(i, 2) == 0
			patch(get(h(i),'XData'),get(h(i),'YData'),'r','FaceAlpha',0.15);
		else
			patch(get(h(i),'XData'),get(h(i),'YData'),'b','FaceAlpha',0.15);
		end
	end

	grid on
	ylabel('Reaction Time [ms]');

	set(gca,'YLim',[0, 700],'gridLineStyle', '-.');
	set(gca,'XLim',[0, 3]);
	set(gca,'XTickLabel','')
    % set(gca,'yTick',[150:50:700]);
    switch test_idx
    case 1
        type_test = '[Mouse]';
        title(['Reaction Time Test ', type_test]);
    case 2
        type_test = '[Mouse]';
        title(['Reaction Time Test ', type_test]);
    case 3
        type_test = '[Keyboard]';
        title(['Reaction Time Test ', type_test]);
    case 4
        type_test = '[Keyboard]';
        title(['Reaction Time Test ', type_test]);
    case 5
        title(['Reaction Time Test with Decision [center]']);
    case 6
        title(['Reaction Time Test with Decision [random]']);
    end
	

	% change the order of legends
	boxes = get(gca, 'Children');

	hold on
 	plot(positions, mean_reaction_time,'db');
	
 	legend(boxes([1, 2]), {'Professional', 'Non-Professional'}, 'location','best');

    figure_count = figure_count + 1;
    figure(figure_count);
    histogram(DATA_pro_concat(:,1));
    grid on
    xlabel('Reaction Time [ms]');
    ylabel('Frequency');
    set(gca,'xtick',[0:50:500])

    title('Histogram of Reaction Time [Mouse]');
    legend('Professional','location','best');

    figure_count = figure_count + 1;
    figure(figure_count);
    histogram(DATA_non_concat(:,1));
    grid on
    xlabel('Reaction Time [ms]');
    ylabel('Frequency');
    set(gca,'xtick',[0:50:500])

    title('Histogram of Reaction Time [Mouse]');
    legend('Non-Professional','location','best');

    % some processing that are not used for visualization
    DATA = DATA_array(1);
    rt = DATA.tests{test_idx}.reaction_time;
    rt = rt(rt > PP_CFG.tests{test_idx}.lower_rt_border);
    rt = rt(rt < PP_CFG.tests{test_idx}.upper_rt_border);
    
    PP_DATA.tests{test_idx}.test_name = CFG_array(1).general.short_names{test_idx};
    PP_DATA.tests{test_idx}.mean_rt = mean(rt);
    PP_DATA.tests{test_idx}.median_rt = median(rt);
    PP_DATA.tests{test_idx}.std_rt = std(rt);
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [num2str(round(PP_DATA.tests{test_idx}.mean_rt)), '+-', num2str(round(PP_DATA.tests{test_idx}.std_rt))];
end