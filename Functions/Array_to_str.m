% function transforms [1,3,2] -> '[1, 3, 2]'
function [str_arr] = Array_to_str(arr)

if isempty(arr)
    str_arr = '[]';
    return
else
    str_arr = ['[',num2str(arr(1))];
end

sz = numel(arr);
for idx = 2:sz
    str_arr = [str_arr, ', ', num2str(arr(idx))];
end
str_arr = [str_arr, ']'];