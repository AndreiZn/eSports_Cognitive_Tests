function [Adj_matrix, nodes_pos] = Form_Adjacency_Matrix(mouse_pos_0, target_pos)

nodes_pos = [mouse_pos_0; target_pos];
num_nodes = size(nodes_pos, 1);

Adj_matrix = zeros(num_nodes, num_nodes);
for i=1:num_nodes
    for j=i+1:num_nodes
        node_1_pos = nodes_pos(i,:);
        node_2_pos = nodes_pos(j,:);
        Adj_matrix(i,j) = sqrt(sum((node_1_pos - node_2_pos).^2))+1e-5;
        Adj_matrix(j,i) = Adj_matrix(i,j);
    end
end

