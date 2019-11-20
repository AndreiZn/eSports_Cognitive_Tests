function [PP_CFG, PP_DATA] = KMC_postprocessing(PP_CFG, PP_DATA, CFG, DATA, test_idx)

PP_DATA.tests{test_idx}.test_name = DATA.tests{test_idx}.test_name;

if ~isfield(DATA.tests{test_idx}, 'time_lasted')
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = '-';
else
    tl = DATA.tests{test_idx}.time_lasted;
    num_cur_obj = DATA.tests{test_idx}.num_current_objects;
    keep_idx = tl > PP_CFG.tests{test_idx}.lower_timelasted_border;
    
    tl = tl(keep_idx);
    PP_DATA.tests{test_idx}.mean_time_lasted = mean(tl);
    PP_DATA.tests{test_idx}.std_time_lasted = std(tl);
    
    idx_mouse = DATA.tests{test_idx}.flag_collision == 1;
    idx_mouse = idx_mouse(keep_idx);
    num_cur_obj = num_cur_obj(keep_idx);
    num_cur_obj_unique = unique(num_cur_obj);
    
    PP_DATA.tests{test_idx}.mean_timelasted = zeros(numel(num_cur_obj_unique), 1);
    PP_DATA.tests{test_idx}.median_timelasted = zeros(numel(num_cur_obj_unique), 1);
    PP_DATA.tests{test_idx}.std_timelasted = zeros(numel(num_cur_obj_unique), 1);
    
    if ~isempty(num_cur_obj)
        for idx = 1:numel(num_cur_obj_unique)
            idx_cur = num_cur_obj == num_cur_obj_unique(idx);
            tl_cur = tl(idx_cur);
            PP_DATA.tests{test_idx}.mean_timelasted(idx,1) = mean(tl_cur);
            PP_DATA.tests{test_idx}.median_timelasted(idx,1) = median(tl_cur);
            PP_DATA.tests{test_idx}.std_timelasted(idx,1) = std(tl_cur);
            
            idx_mouse_cur = logical (idx_cur.*idx_mouse);
            tl_cur_mouse = tl(idx_mouse_cur);
            PP_DATA.tests{test_idx}.mean_timelasted_mouse(idx,1) = mean(tl_cur_mouse);
            PP_DATA.tests{test_idx}.median_timelasted_mouse(idx,1) = median(tl_cur_mouse);
            PP_DATA.tests{test_idx}.std_timelasted_mouse(idx,1) = std(tl_cur_mouse);
            
            idx_kb_cur = logical (idx_cur.*~idx_mouse);
            tl_cur_kb = tl(idx_kb_cur);
            PP_DATA.tests{test_idx}.mean_timelasted_kb(idx,1) = mean(tl_cur_kb);
            PP_DATA.tests{test_idx}.median_timelasted_kb(idx,1) = median(tl_cur_kb);
            PP_DATA.tests{test_idx}.std_timelasted_kb(idx,1) = std(tl_cur_kb);
        end
    end
    
    PP_DATA.tests{test_idx}.num_objects = num_cur_obj_unique;
    
    PP_DATA.tests{test_idx}.total_num_mouse_collisions = sum(DATA.tests{test_idx}.flag_collision);
    PP_DATA.tests{test_idx}.total_num_keyboard_collisions = sum(~DATA.tests{test_idx}.flag_collision);
    
    PP_DATA.tests{test_idx}.key_factor_name = PP_CFG.tests{test_idx}.key_factor_name;
    PP_DATA.tests{test_idx}.key_factor = [Array_to_str(num_cur_obj_unique), '->', Array_to_str(round(PP_DATA.tests{test_idx}.mean_timelasted, 1))];
end