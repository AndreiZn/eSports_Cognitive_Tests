% function uses Screen('DrawText', ...) function to display subject's
% results
% SHORT DESCRIPTION:
% results: double-type array of results
% results_description: cell array with descritption of results
% results_dimension: cell array with dimensions of results ('ms', 'pix',
% and so on)
% position: 'center' or 'upperleft', determines where to show the results
% on the screen

function Display_Results(CFG_general, results, results_description, results_dimension, position)

res_round = arrayfun(@(x) round(x), results);
res = cellstr(string(res_round));

num_lines = numel(results);

lines = cell(num_lines, 1);
for idx = 1:numel(results)
    lines{idx,1} = [results_description{idx}, res{idx}, ' ', results_dimension{idx}];
end

if strcmp(position, 'center')
    for i = 1:num_lines
        Screen('DrawText', CFG_general.win, lines{i}, ...
            CFG_general.centerXY(1) - 0.1*CFG_general.theRect(3), CFG_general.centerXY(2) + (i-2)*0.05*CFG_general.theRect(4), ...
            CFG_general.textcolor);
    end
else
    for i = 1:num_lines
        Screen('DrawText', CFG_general.win, lines{i}, ...
            CFG_general.theRect(1) + 0.05*CFG_general.theRect(3), i*0.05*CFG_general.theRect(4), ...
            CFG_general.textcolor); 
    end
end
