% function uses Screen('DrawText', ...) function to display several lines
% in the center of the screen
% N various lines should be put in different columns, i.e. lines has
% dimensions (1, N)
function Display_text(CFG_general, lines)

num_lines = size(lines, 2);

if mod(num_lines, 2)
    pos_coef = -num_lines/2 + 0.5:1:num_lines/2 - 0.5;
else
    pos_coef = -num_lines/2:1:num_lines/2;
end

for line_idx = 1:num_lines
    line = lines{1, line_idx};
    Screen('DrawText', CFG_general.win, line, ... 
            CFG_general.centerXY(1) - floor(length(line) * CFG_general.font_size / 4), ...
            CFG_general.centerXY(2) + pos_coef(line_idx)*CFG_general.vertical_text_distance, CFG_general.textcolor);
end
Screen('Flip', CFG_general.win);
