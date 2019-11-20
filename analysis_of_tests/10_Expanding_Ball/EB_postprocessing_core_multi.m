function [PP_CFG, PP_DATA] = EB_postprocessing_core_multi(PP_CFG, PP_DATA, CFG_array, DATA_array, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA_array(1).tests{test_idx}.test_name;

num_data = size(DATA_array, 2);
flag_all_data_valid = true;
figure_count = 0;
DATA_array2 = [];
for idx = 1:num_data
    if ~isfield(DATA_array(idx).tests{test_idx}, 'error_radius')
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
    
    error_radius_pro = [];
    error_radius_non = [];

    for idx = 1:size(DATA_pro, 1)
        error_radius = DATA_pro(idx).tests{test_idx}.error_radius;
        error_radius_pro = [error_radius_pro; error_radius];
    end

    for idx = 1:size(DATA_non, 1)
        error_radius = DATA_non(idx).tests{test_idx}.error_radius;
        error_radius_non = [error_radius_non; error_radius];
    end

    mean_error_radius_pro = mean(error_radius_pro);
    mean_error_radius_non = mean(error_radius_non);
    mean_error_radius = [mean_error_radius_pro, mean_error_radius_non];
    
    % box plot
    box_data = [error_radius_pro; error_radius_non];
    group_category = [ones(length(error_radius_pro), 1); 2 * ones(length(error_radius_non), 1)];
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
    ylim_max = max([mean_error_radius_pro; mean_error_radius_non]) + 5;
    set(gca,'gridLineStyle', '-.');
    set(gca,'XLim',[0, 3]);
    set(gca,'XTickLabel','')
    % set(gca,'yTick',[150:50:700]);
    ylabel('Capture Error [pixel]');

    switch test_idx
    case 13
        title('Expanding Ball Test [Constant Speed & Radius]');
    case 14
        title('Expanding Ball Test [Random Speed]');
    case 15
        title('Expanding Ball Test [Random SPeed & Radius]');
    case 16
        title('Expanding Ball Test [Beating Boundry]');
    end
        % change the order of legends
    boxes = get(gca, 'Children');
    hold on
    plot(positions, mean_error_radius,'db');
    legend(boxes([1, 2]), {'Professional', 'Non-Professional'}, 'location','best');
        
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [num2str(round(mean_error_radius))];
end