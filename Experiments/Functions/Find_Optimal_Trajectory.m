% Finds the Optimal tour and its length from mouse_pos_0 to all target_pos
% Index of the first point (mouse_pos_0) in the Optimal_length array is 1; all other points have indices >1 
function [OptimalTour, Optimal_length] = Find_Optimal_Trajectory(mouse_pos_0, target_pos)

    [Adj_matrix, nodes_pos] = Form_Adjacency_Matrix(mouse_pos_0, target_pos);
    
    [OptimalTour,mincost]=tsp_dp1(nodes_pos, Adj_matrix); % Optimal Tour from point 1 to all other points and back to point 1
    
    second_to_last_point = OptimalTour(end-1);
    d_last_and_sec_2_last = Adj_matrix(1, second_to_last_point);
    
    OptimalTour = OptimalTour(1:end-1);
    Optimal_length = mincost - d_last_and_sec_2_last;
    
end