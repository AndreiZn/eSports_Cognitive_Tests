function [PP_CFG, PP_DATA] = REC_postprocessing_multi(PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA_array(1).tests{test_idx}.test_name;

num_data = size(DATA_array, 2);
flag_all_data_valid = true;
figure_count = 0;
DATA_array2 = [];
for idx = 1:num_data
    if ~isfield(DATA_array(idx).tests{test_idx}, 'num_bursts')
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

    recoil_coef_pro = [];
    recoil_coef_non = [];
    % concatenate data of each group into one column
    for idx = 1:size(DATA_pro, 1)
        num_bursts = DATA_pro(idx).tests{test_idx}.num_bursts;
        shots_used = DATA_pro(idx).tests{test_idx}.shots_used;
        shots_to_kill = DATA_pro(idx).tests{test_idx}.shots_to_kill;

        normalized_num_bursts = num_bursts ./ shots_to_kill;
        accuracy_percentage = 100 * shots_to_kill ./ shots_used;
        performance = accuracy_percentage ./ normalized_num_bursts;
        performance_max = 100 ./ (1 ./ shots_to_kill);

        recoil_coef = performance ./ performance_max;
        recoil_coef_pro = [recoil_coef_pro; recoil_coef];
    end
    
    for idx = 1:size(DATA_non, 1)
        num_bursts = DATA_non(idx).tests{test_idx}.num_bursts;
        shots_used = DATA_non(idx).tests{test_idx}.shots_used;
        shots_to_kill = DATA_non(idx).tests{test_idx}.shots_to_kill;

        normalized_num_bursts = num_bursts ./ shots_to_kill;
        accuracy_percentage = 100 * shots_to_kill ./ shots_used;
        performance = accuracy_percentage ./ normalized_num_bursts;
        performance_max = 100 ./ (1 ./ shots_to_kill);

        recoil_coef = performance ./ performance_max;
        recoil_coef_non = [recoil_coef_non; recoil_coef];
    end
    
    % box plot
	box_data = [recoil_coef_pro; recoil_coef_non];
    group_category = [ones(length(recoil_coef_pro), 1); 2 * ones(length(recoil_coef_non), 1)];
    positions = [1,2]; % positions of boxes

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
    % ylim_max = max([mean_error_radius_pro; mean_error_radius_non]) + 5;
    set(gca,'gridLineStyle', '-.');
    set(gca,'XLim',[0, 3]);
    set(gca,'XTickLabel','')
    % set(gca,'yTick',[150:50:700]);
    ylabel('Recoil Control Coefficient');

    title('Recoil Control Test');

        % change the order of legends
    boxes = get(gca, 'Children');
    hold on

    mean_recoil_coef = [mean(recoil_coef_pro), mean(recoil_coef_non)];
    plot(positions, mean_recoil_coef,'db');
    legend(boxes([1, 2]), {'Professional', 'Non-Professional'}, 'location','best');

    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    %PP_DATA.tests{test_idx}.key_factor = [Array_to_str(num_target_unique), '->', Array_to_str(100*round(PP_DATA.tests{test_idx}.mean_accuracy_per_level, 2))];
    PP_DATA.tests{test_idx}.key_factor = '-';
end