res_x_pix = 1600;
res_y_pix = 900;

size_x_cm = 60; % cm - screen horizontal size
size_y_cm = 40; % cm - screen horizontal size

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

E = [0, 0];
F = [0, res_y_pix];
G = [res_x_pix, res_y_pix];
H = [res_x_pix 0];

txt_shift = 15;
scatter(A(1), A(2))
hold on

% focus area
coor_foc = [A; B; C; D];  
patch(coor_foc(:,1), coor_foc(:,2),'r')
[inPoints_foc] = polygrid(coor_foc(:,1), coor_foc(:,2), 1);

% left area
coor_l = [E; A; B; F]; 
p = patch(coor_l(:,1), coor_l(:,2),[0.5 0.25 0.25]);
[inPoints_l] = polygrid(coor_l(:,1), coor_l(:,2), 1);

% upper area
coor_u = [B; F; G; C];
patch(coor_u(:,1), coor_u(:,2),'b')
[inPoints_u] = polygrid(coor_u(:,1), coor_u(:,2), 1);

% right area
coor_r = [C; G; H; D];
patch(coor_r(:,1), coor_r(:,2),'y')
[inPoints_r] = polygrid(coor_r(:,1), coor_r(:,2), 1);

% bottom area
coor_b = [E; A; D; H];
patch(coor_b(:,1), coor_b(:,2),'g')
[inPoints_b] = polygrid(coor_b(:,1), coor_b(:,2), 1);

text(A(1)+txt_shift, A(2)+txt_shift, 'A')
scatter(B(1), B(2))
text(B(1)+txt_shift, B(2)+txt_shift, 'B')
scatter(C(1), C(2))
text(C(1)+txt_shift, C(2)+txt_shift, 'C')
scatter(D(1), D(2))
text(D(1)+txt_shift, D(2)+txt_shift, 'D')
scatter(E(1), E(2))
text(E(1)+txt_shift, E(2)+txt_shift, 'E')
scatter(F(1), F(2))
text(F(1)+txt_shift, F(2)+txt_shift, 'F')
scatter(G(1), G(2))
text(G(1)+txt_shift, G(2)+txt_shift, 'G')
scatter(H(1), H(2))
text(H(1)+txt_shift, H(2)+txt_shift, 'H')

axis([0-txt_shift res_x_pix+txt_shift 0-txt_shift res_y_pix+txt_shift])

total_area = res_x_pix * res_y_pix;
area_foc = round(100* foc_x_pix * foc_y_pix / total_area,1);
area_left = round(100 * 0.5*(B(1)-F(1))*(B(2)-A(2) + F(2)-E(2)) / total_area, 1);
area_upper = round(100 * 0.5*(F(2) - B(2))*(C(1) - B(1) + G(1) - F(1)) / total_area, 1);
area_right = round(100 * 0.5*(G(1)-C(1))*(C(2)-D(2) + G(2)-H(2)) / total_area, 1);
area_bottom = round(100 * 0.5*(A(2)-E(2))*(D(1)-A(1) + H(1)-E(1)) / total_area, 1);

num_areas = 5;
num_trials_per_area = 12;
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

for idx = 1:size(circle_coordinates,1)
    viscircles(circle_coordinates(idx,:),30,'Color',[0.45 0.65 0])
end

    




