function [PP_CFG, PP_DATA] = OT_postprocessing_multi(PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx)

P_DATA.tests{test_idx}.test_name = DATA_array(1).tests{test_idx}.test_name;

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

    time_reaction_average = PP_CFG.tests{test_idx}.default_reaction_time;
    PP_DATA.tests{test_idx}.default_reaction_time_used = 1;
    
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
    
    coef_pro = [];
    coef_non = [];
    optimality_pro = [];
    optimality_non = [];

    for idx = 1:size(DATA_pro, 1)
        num_trials = DATA_pro(idx).tests{test_idx}.num_trials;

        for i_trial = 1:num_trials
            traj_mouse = DATA_pro(idx).tests{test_idx}.mouse_trajectory{i_trial}; % an array
            pos_mouse_0= traj_mouse(1,:);
            pos_target = DATA_pro(idx).tests{test_idx}.target_pos{i_trial, :}; % a vector

            [Optimal_Tour, Optimal_Length] = Find_Optimal_Trajectory(pos_mouse_0, pos_target);
            length_traj_mouse = sum(sum(diff(traj_mouse) .^ 2, 2) .^ 0.5);

            optimality = Optimal_Length / length_traj_mouse;
            optimality_pro = [optimality_pro; optimality];

            reaction_time_click = 1000 * DATA_pro(idx).tests{test_idx}.reaction_time_click{i_trial};
            reaction_time_click = diff([0; reaction_time_click]);
            reaction_time_click(1) = reaction_time_click(1) - time_reaction_average;

            pos_click = DATA_pro(idx).tests{test_idx}.pos_click{i_trial};
            distance_click = sum(diff([pos_mouse_0; pos_click]) .^ 2, 2) .^ 0.5;

            coef_click = distance_click ./ reaction_time_click / CFG_array(1).general.ratio_pixel;
            coef_pro = [coef_pro; reshape(coef_click, [], 1)];
        end
    end

    for idx = 1:size(DATA_non, 1)
        num_trials = DATA_non(idx).tests{test_idx}.num_trials;

        for i_trial = 1:num_trials
            traj_mouse = DATA_non(idx).tests{test_idx}.mouse_trajectory{i_trial}; % an array
            pos_mouse_0= traj_mouse(1,:);
            pos_target= DATA_non(idx).tests{test_idx}.target_pos{i_trial, :}; % a vector

            [Optimal_Tour, Optimal_Length] = Find_Optimal_Trajectory(pos_mouse_0, pos_target);
            length_traj_mouse = sum(sum(diff(traj_mouse) .^ 2, 2) .^ 0.5);

            optimality = Optimal_Length / length_traj_mouse;
            optimality_non = [optimality_non; optimality];

            reaction_time_click = 1000 * DATA_non(idx).tests{test_idx}.reaction_time_click{i_trial};
            reaction_time_click = diff([0; reaction_time_click]);
            reaction_time_click(1) = reaction_time_click(1) - time_reaction_average;

            pos_click = DATA_non(idx).tests{test_idx}.pos_click{i_trial};
            distance_click = sum(diff([pos_mouse_0; pos_click]) .^ 2, 2) .^ 0.5;

            coef_click = distance_click ./ reaction_time_click / CFG_array(1).general.ratio_pixel;
            coef_non = [coef_non; reshape(coef_click, [], 1)];
        end
    end

    mean_optimality_pro = mean(optimality_pro(:));
    mean_optimality_non = mean(optimality_non(:));
    mean_optimality = [mean_optimality_pro, mean_optimality_non];

    mean_coef_pro = mean(coef_pro(:));
    mean_coef_non = mean(coef_non(:));
    mean_coef = [mean_coef_pro, mean_coef_non];
    
    % box plot
    box_data = [optimality_pro; optimality_non];
    group_category = [ones(length(optimality_pro), 1); 2 * ones(length(optimality_non), 1)];
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
    ylim_max = max([mean_optimality_pro; mean_optimality_non]) + 0.3;
    set(gca,'YLim',[0, ylim_max],'gridLineStyle', '-.');
    set(gca,'XLim',[0, 3]);
    set(gca,'XTickLabel','')
    % set(gca,'yTick',[150:50:700]);
    ylabel('Aiming Trajectory Optimality');
    title('Optimal Trajectory Test');

    % change the order of legends
    boxes = get(gca, 'Children');
    hold on
    plot(positions, mean_optimality,'db');
    legend(boxes([1, 2]), {'Professional', 'Non-Professional'}, 'location','best');


    % box plot
    box_data = [coef_pro; coef_non];
    group_category = [ones(length(coef_pro), 1); 2 * ones(length(coef_non), 1)];
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
    % ylim_max = max([mean_coef_pro; mean_coef_non]) + 0.3;
    % set(gca,'YLim',[0, ylim_max],'gridLineStyle', '-.');
    set(gca,'XLim',[0, 3]);
    set(gca,'XTickLabel','')
    % set(gca,'yTick',[150:50:700]);
    ylabel('Aiming Coefficient [pixel/ms]');
    title('Optimal Trajectory Test');

    % change the order of legends
    boxes = get(gca, 'Children');
    hold on
    plot(positions, mean_optimality,'db');
    legend(boxes([1, 2]), {'Professional', 'Non-Professional'}, 'location','best');


    % figure_count = figure_count + 1;
	% f = figure(figure_count);
    % bar(1, mean_optimality_pro);
    % grid on;
	% hold on;
    % bar(4, mean_optimality_non);
    
    % set(gca,'XTickLabel','');
	% ylim([0, 1]);
	% xlabel(' ');
	% ylabel('Average Aiming Trajectory Optimality');
	% title('Optimal Trajectory Test');
	% legend('Professional','Non-Professional','location','best')
    
    % figure_count = figure_count + 1;
	% f = figure(figure_count);
    % bar(1, mean_coef_pro);
    % grid on;
	% hold on;
    % bar(3, mean_coef_non);
    
    % set(gca,'XTickLabel','');
    % ylim_max = max([mean_coef_pro; mean_coef_non]) + 0.1;
	% ylim([0, ylim_max]);
	% xlabel(' ');
	% ylabel('Average Aiming Coefficient [pixel/ms]');
	% title('Optimal Trajectory Test');
    % legend('Professional','Non-Professional','location','best')
    
    PP_DATA.tests{test_idx}.aiming_coef = coef_pro;
    PP_DATA.tests{test_idx}.mean_aiming_coef = mean(coef_pro(:));
    PP_DATA.tests{test_idx}.median_aiming_coef = median(coef_pro(:));
    PP_DATA.tests{test_idx}.std_aiming_coef = std(coef_pro(:));
    PP_DATA.tests{test_idx}.trajectory_optimality = optimality_pro;
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
end