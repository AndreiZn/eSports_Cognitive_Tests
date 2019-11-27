% Function Generate_random_coordinates_in_5_areas generates an array
% circle_coordinates of the size (num_areas * num_trials_per_area, 2)
% this coordinates are used when it is necessary to display circles randomly, but with equal number of
% circles at each area
%
% the array circle_coordinates is already shuffled
%
% See the script draw_area_for_RT_test.m for visualization
function [circle_coordinates] = Generate_random_coordinates_in_5_areas(CFG, test_idx)

CFG_test = CFG.tests{test_idx};
num_areas = CFG_test.num_areas;
num_trials_per_area = CFG_test.num_trials_per_area;

res_x_pix = CFG.general.theRect(3);
res_y_pix = CFG.general.theRect(4);

size_x_cm = CFG.general.horizontal_size_cm; % cm - screen horizontal size
size_y_cm = CFG.general.vertical_size_cm; % cm - screen horizontal size

dist_from_screen = 60; % cm
angle_x = 30*pi/180; % rad
angle_y = 20*pi/180; % rad

foc_x = 2*dist_from_screen*tan(angle_x/2); % cm - constant for any screen
foc_y = 2*dist_from_screen*tan(angle_y/2); % cm - constant for any screen

foc_x_pix = foc_x * res_x_pix/size_x_cm;
foc_y_pix = foc_y * res_y_pix/size_y_cm;

A = [res_x_pix/2 - foc_x_pix/2, res_y_pix/2 - foc_y_pix/2];
B = [res_x_pix/2 - foc_x_pix/2, res_y_pix/2 + foc_y_pix/2];
C = [res_x_pix/2 + foc_x_pix/2, res_y_pix/2 + foc_y_pix/2];
D = [res_x_pix/2 + foc_x_pix/2, res_y_pix/2 - foc_y_pix/2];

delta = 0.5 * CFG_test.radius_circle; % shift the border points E, F, G, H to ensure that the circle is fully displayed on the screen

E = [0 + delta, 0 + delta];
F = [0 + delta, res_y_pix - delta];
G = [res_x_pix - delta,  res_y_pix - delta];
H = [res_x_pix - delta, 0 + delta];

% focus area
coor_foc = [A; B; C; D];  
[inPoints_foc] = polygrid(coor_foc(:,1), coor_foc(:,2), 1);

% left area
coor_l = [E; A; B; F]; 
[inPoints_l] = polygrid(coor_l(:,1), coor_l(:,2), 1);

% upper area
coor_u = [B; F; G; C];
[inPoints_u] = polygrid(coor_u(:,1), coor_u(:,2), 1);

% right area
coor_r = [C; G; H; D];
[inPoints_r] = polygrid(coor_r(:,1), coor_r(:,2), 1);

% bottom area
coor_b = [E; A; D; H];
[inPoints_b] = polygrid(coor_b(:,1), coor_b(:,2), 1);

circle_coordinates = zeros(num_areas*num_trials_per_area, 2);

rand_idx = randi(size(inPoints_foc,1),num_trials_per_area,1);
rand_coord = inPoints_foc(rand_idx,:);
circle_coordinates(1:num_trials_per_area,:) = rand_coord;

rand_idx = randi(size(inPoints_l,1),num_trials_per_area,1);
rand_coord = inPoints_l(rand_idx,:);
circle_coordinates(1+num_trials_per_area:2*num_trials_per_area,:) = rand_coord;

rand_idx = randi(size(inPoints_u,1),num_trials_per_area,1);
rand_coord = inPoints_u(rand_idx,:);
circle_coordinates(1+2*num_trials_per_area:3*num_trials_per_area,:) = rand_coord;

rand_idx = randi(size(inPoints_r,1),num_trials_per_area,1);
rand_coord = inPoints_r(rand_idx,:);
circle_coordinates(1+3*num_trials_per_area:4*num_trials_per_area,:) = rand_coord;

rand_idx = randi(size(inPoints_b,1),num_trials_per_area,1);
rand_coord = inPoints_b(rand_idx,:);
circle_coordinates(1+4*num_trials_per_area:5*num_trials_per_area,:) = rand_coord;

rand_perm = randperm(size(circle_coordinates,1));
circle_coordinates = circle_coordinates(rand_perm,:);
