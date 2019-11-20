function [error] = MEM_MOT_Calculate_error(click_pos_trial, grid_pos_trial) % error in num_cell units (Memory test) or pixels (MOT)

error = 0;
identified_clicks = [];
num_objects = size(grid_pos_trial, 1);

for grid_obj_idx = 1:num_objects
    dist_min = Inf;
    for click_obj_idx = setdiff(1:num_objects, identified_clicks)
        
        grid_pos = grid_pos_trial(grid_obj_idx, :);
        click_pos = click_pos_trial(click_obj_idx, :);
        
        if sum(grid_pos == click_pos) == 2
            dist_min_idx = click_obj_idx;
            dist_min = 0;
            break; 
        else
            dist = sqrt(sum((grid_pos - click_pos).^2));
            if dist < dist_min
                dist_min = dist;
                dist_min_idx = click_obj_idx;
            end
        end
    end
    error = error + dist_min;
    identified_clicks = [identified_clicks, dist_min_idx];
end