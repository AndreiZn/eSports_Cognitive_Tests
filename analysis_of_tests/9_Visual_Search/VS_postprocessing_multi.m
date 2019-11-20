function [PP_CFG, PP_DATA] = VS_postprocessing_multi(PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA_array(1).tests{test_idx}.test_name;

num_data = size(DATA_array, 2);
flag_all_data_valid = true;
figure_count = 0;
DATA_array2 = [];
for idx = 1:num_data
    if ~isfield(DATA_array(idx).tests{test_idx}, 'final_score')
        disp(['invalid data in test no. ', num2str(test_idx), ', ' , DATA_array(idx).general.sub_id]);
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
    
    final_score_pro = [];
    final_score_non = [];
    time_reaction_L_pro = [];
    time_reaction_L_non = [];

    for idx = 1:size(DATA_pro, 1)
        final_score = DATA_pro(idx).tests{test_idx}.final_score;
        final_score_pro = [final_score_pro; final_score];

        correct_ans = DATA_pro(idx).tests{test_idx}.correct_ans;
        answered_correct = DATA_pro(idx).tests{test_idx}.answered_correct;
        time_reaction = 1000 * DATA_pro(idx).tests{test_idx}.time_reaction;
        time_reaction_L = time_reaction(logical((correct_ans == 1) .* (answered_correct == 1)));
        time_reaction_L_pro = [time_reaction_L_pro; time_reaction_L];
    end

    for idx = 1:size(DATA_non, 1)
        final_score = DATA_non(idx).tests{test_idx}.final_score;
        final_score_non = [final_score_non; final_score];

        correct_ans = DATA_non(idx).tests{test_idx}.correct_ans;
        answered_correct = DATA_non(idx).tests{test_idx}.answered_correct;
        time_reaction = 1000 * DATA_non(idx).tests{test_idx}.time_reaction;
        time_reaction_L = time_reaction(logical((correct_ans == 1) .* (answered_correct == 1)));
        time_reaction_L_non = [time_reaction_L_non; time_reaction_L];
    end

    mean_final_score_pro = mean(final_score_pro(:));
    mean_final_score_non = mean(final_score_non(:));
    mean_final_score = [mean_final_score_pro, mean_final_score_non];

    mean_time_reaction_L_pro = mean(time_reaction_L_pro(:));
    mean_time_reaction_L_non = mean(time_reaction_L_non(:));
    mean_time_reaction_L = [mean_time_reaction_L_pro, mean_time_reaction_L_non];
    
    % box plot
    box_data = [final_score_pro; final_score_non];
    group_category = [ones(length(final_score_pro), 1); 2 * ones(length(final_score_non), 1)];
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
    ylim_max = max([mean_final_score_pro; mean_final_score_non]) + 5;
    set(gca, 'gridLineStyle', '-.');
    set(gca,'XLim',[0, 3]);
    set(gca,'XTickLabel','')
    % set(gca,'yTick',[150:50:700]);
    ylabel('Test Score');
    title('Visual Search Test');

    % change the order of legends
    boxes = get(gca, 'Children');
    hold on
    plot(positions, mean_final_score,'db');
    legend(boxes([1, 2]), {'Professional', 'Non-Professional'}, 'location','best');
    
    % box plot
    box_data = [time_reaction_L_pro; time_reaction_L_non];
    group_category = [ones(length(time_reaction_L_pro), 1); 2 * ones(length(time_reaction_L_non), 1)];
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
    % ylim_max = max([mean_time_reaction_L_pro; mean_time_reaction_L_non]) + 200;
    set(gca,'gridLineStyle', '-.');
    set(gca,'XLim',[0, 3]);
    set(gca,'XTickLabel','')
    % set(gca,'yTick',[150:50:700]);
    ylabel('Reaction Time with ''L'' present [ms]');
    title('Visual Search Test');

    % change the order of legends
    boxes = get(gca, 'Children');
    hold on
    plot(positions, mean_time_reaction_L,'db');
    legend(boxes([1, 2]), {'Professional', 'Non-Professional'}, 'location','best');

    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [num2str(round(mean(time_reaction_L), 2)), '+-', num2str(round(std(time_reaction_L),2))];
end