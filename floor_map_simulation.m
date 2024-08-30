clear all
clc
clf

% Walls initialization for drawing 
Walls_rect = [
    0,0,6,15;
    6,0,8,15;
    14,0,8,8;
    14,8,8,7;
    22,0,3,15;
    25,0,2,15;
    27,0,3,15;
    30,0,8,8;
    30,8,8,7;
    38,0,8,15;
    46,0,6,15;
    0,15,2,5;
    2,16.5,4,3.5;
    6,16.5,4,3.5;
    10,16.5,4,3.5;
    14,16.5,4,3.5;
    18,16.5,4,3.5;
    22,16.5,4,3.5;
    26,16.5,4,3.5;
    30,16.5,4,3.5; 
    34,16.5,4,3.5;
    38,16.5,4,3.5;
    42,16.5,4,3.5
];

AP1 = [6,15.5625];
AP2 = [17.5,4];
AP3 = [25.5,15.5625];
AP4 = [33.5,4];
AP5 = [45,15.5625];

% Defining the Access Points for drawing last 2 coordinates are length and width.
APs = [
    6,15.5625,2,0.5;
    17.5,4,2,0.5;
    25.5,15.5625,2,0.5;
    33.5,4,2,0.5;
    45,15.5625,2,0.5
];

figure('Name', 'Floor Map')
title('Floor Map')

% Drawing the walls
axis([0 50 0 20])  % Set axis once, outside the loop
for i = 1:length(Walls_rect)
    if i <= 11
        rectangle('Position', Walls_rect(i,:), 'FaceColor', 'w', 'LineWidth', 2)
    else
        rectangle('Position', Walls_rect(i,:), 'FaceColor', 'g', 'LineWidth', 2)
    end
end

% Drawing the Access Points,.,.
hold on
for i = 1:length(APs)
    rectangle('Position', APs(i,:), 'FaceColor', 'b', 'LineStyle', ':')
end

%------------------------------ Start of Localization ----------------

% Initialize the reference points.
ref_points = [];
for i = 1:0.5:52
    for j = 1:0.5:20
        ref_points = [ref_points; i, j];  
    end
end

% Aggregating all access points in one array for iteration.
APs_array = [AP1; AP2; AP3; AP4; AP5];

% Define walls matrix
walls = [
    0 52 15 15;
    6 6 0 15;
    14 14 0 15;
    22 22 0 15;
    25 25 0 15;
    27 27 0 15;
    30 30 0 15;
    38 38 0 15;
    46 46 0 15;
    52 52 0 15;
    14 22 8 8;
    30 38 8 8;
    2 46 16.5 16.5;
    6 6 16.5 20;
    10 10 16.5 20;
    14 14 16.5 20;
    18 18 16.5 20;
    22 22 16.5 20;
    26 26 16.5 20;
    30 30 16.5 20;
    34 34 16.5 20;
    38 38 16.5 20;
    42 42 16.5 20;
    46 46 16.5 20;
    2 2 15 20
];

% Constants
n = 3;
c = 3*(10^8);
f = 2.4*(10^9);
lambda = c/f;
PAF = 3;

% Calculate power received at each reference point from each AP
ref_powers = zeros(size(ref_points, 1), length(APs_array)); % Preallocating for efficiency

for i = 1:size(ref_points, 1)
    x = ref_points(i, 1);
    y = ref_points(i, 2);
    
    power_access_point = zeros(1, length(APs_array));
    for j = 1:length(APs_array)
        x_ap = APs_array(j, 1);
        y_ap = APs_array(j, 2);
       
        d = sqrt((x_ap - x)^2 + (y_ap - y)^2);
        path_loss = ((2*pi*d)/lambda)^n;
        p_loss_dB = 10*log10(path_loss);
        
        wall_sum = 0;
        for wall = 1:size(walls, 1)
            wall_ax = walls(wall,:);
            x_wall = wall_ax([1, 2]);
            y_wall = wall_ax([3, 4]);
               
            [x_intersect, y_intersect] = line_intersect([x_wall(1), x_wall(2), y_wall(1), y_wall(2)], [x, x_ap, y, y_ap]);
            points = length(x_intersect);
            wall_sum = wall_sum + points;
        end
        power = -10 - p_loss_dB - (PAF * wall_sum);
        power_access_point(j) = power;
    end
    ref_powers(i, :) = power_access_point;
end

% Contour map drawing
for apoint = 1:length(APs_array)
    accessPointPowers = [ref_points(:, 1), ref_points(:, 2), ref_powers(:, apoint)];
    
    [x_values, x_values_indices] = unique(accessPointPowers(:, 1));
    indexDifference = diff(x_values_indices);
    
    apReshaped = reshape(accessPointPowers, indexDifference(1), [], size(accessPointPowers, 2));
    x_coo = apReshaped(:,:,1);
    y_coo = apReshaped(:,:,2);
    p_val = apReshaped(:,:,3);

    figure('Name', sprintf('Access Point Power Heat Map %d', apoint))
    contourf(x_coo, y_coo, p_val)
end

% Get user input for received power
AP1 = input('Enter received power from AP1 = ');
AP2 = input('Enter received power from AP2 = ');
AP3 = input('Enter received power from AP3 = ');
AP4 = input('Enter received power from AP4 = ');
AP5 = input('Enter received power from AP5 = ');

user = zeros(1, size(ref_powers, 1)); % Preallocate user power difference array
userInput = [AP1, AP2, AP3, AP4, AP5];

for p = 1:size(ref_powers, 1)
    userPowerDiff1 = (userInput(1) - ref_powers(p, 1))^2;
    userPowerDiff2 = (userInput(2) - ref_powers(p, 2))^2;
    userPowerDiff3 = (userInput(3) - ref_powers(p, 3))^2;
    userPowerDiff4 = (userInput(4) - ref_powers(p, 4))^2;
    userPowerDiff5 = (userInput(5) - ref_powers(p, 5))^2;
    
    user(p) = userPowerDiff1 + userPowerDiff2 + userPowerDiff3 + userPowerDiff4 + userPowerDiff5;
end

closest = find(user == min(user), 1); % Find the closest match
userPosition = ref_points(closest, :);

fprintf('The user is approximately located at (%.2f, %.2f)\n', userPosition(1), userPosition(2));

% Function definitions remain unchanged
function [x_intersect, y_intersect] = line_intersect(line1, line2)
    % line1 and line2 are in the form [x1 x2 y1 y2]
    x1 = line1(1);
    x2 = line1(2);
    y1 = line1(3);
    y2 = line1(4);
    
    x3 = line2(1);
    x4 = line2(2);
    y3 = line2(3);
    y4 = line2(4);

    % Calculate the denominator
    denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    % Initialize outputs
    x_intersect = [];
    y_intersect = [];

    % Check if the lines are parallel (denominator is zero)
    if abs(denominator) < 1e-10
        return; % No intersection if lines are parallel
    end

    % Calculate the intersection point using determinants
    det1 = (x1 * y2 - y1 * x2);
    det2 = (x3 * y4 - y3 * x4);

    px = (det1 * (x3 - x4) - (x1 - x2) * det2) / denominator;
    py = (det1 * (y3 - y4) - (y1 - y2) * det2) / denominator;

    % Check if the intersection point is within the line segments
    if is_within(px, py, x1, y1, x2, y2) && is_within(px, py, x3, y3, x4, y4)
        x_intersect = px;
        y_intersect = py;
    end
end

function inside = is_within(px, py, x1, y1, x2, y2)
    % Check if a point (px, py) lies on the line segment (x1, y1) to (x2, y2)
    inside = (min(x1, x2) <= px && px <= max(x1, x2)) && ...
             (min(y1, y2) <= py && py <= max(y1, y2));
end
