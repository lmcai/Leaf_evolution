function [teeth_number] = teeth_counting(bw,file_name)
bw = im2bw(bw); % Ensure it is binary (if not already)

% Extract the leaf boundary
[B, ~] = bwboundaries(bw, 'noholes');

% Select the largest boundary (assuming the leaf is the largest object)
boundary = B{1};

% Extract x and y coordinates of the boundary
x = boundary(:,2);
y = boundary(:,1);

% Compute the convex hull
K = convhull(x, y);
hull_x = x(K);
hull_y = y(K);

% Compute accurate distance of each boundary point to the convex hull edges
num_outline = length(x);
num_hull = length(hull_x);
distances = zeros(num_outline, 1);

for i = 1:num_outline
    px = x(i);
    py = y(i);
    
    min_dist = inf; % Start with a large distance
    
    % Check distance to each convex hull edge segment
    for j = 1:(num_hull - 1)
        x1 = hull_x(j); 
        y1 = hull_y(j);
        x2 = hull_x(j+1); 
        y2 = hull_y(j+1);
        
        % Compute perpendicular distance from (px, py) to segment (x1,y1) - (x2,y2)
        d = point_to_line_segment_distance(px, py, x1, y1, x2, y2);
        
        % Update minimum distance
        if d < min_dist
            min_dist = d;
        end
    end
    
    distances(i) = min_dist; % Store the minimum distance
end

% Identify the starting point (first boundary point)
start_x = x(1);
start_y = y(1);
start_distance = distances(1);

% Smooth the distance function to reduce noise
window_size = 5; % Adjust for more/less smoothing
distances_smooth = movmean(distances, window_size);

% Detect valleys (local minima) in the distance function to get a distribution of the prominence
[valleys,locs,widths,proms] = findpeaks(-distances_smooth);

% Set adaptive threshold for detecting valleys
% min_height = mean(distances_smooth) - std(distances_smooth); % Dynamic threshold
min_prominence = median(proms) * 0.5; % Adjust for meaningful valleys
% [valleys, locs] = findpeaks(-distances_smooth, 'MinPeakHeight', -min_height, 'MinPeakProminence', min_prominence);
[valleys, locs] = findpeaks(-distances_smooth, 'MinPeakProminence', min_prominence);

% ---------------- Return the number of teeth ---------------

teeth_number = length(locs);

% ---------------- Save plots ---------------
fig = figure('Visible', 'off');
imshow(bw);
hold on;
plot(hull_x, hull_y, 'g-', 'LineWidth', 2);
plot(x(locs), y(locs), 'ro', 'MarkerSize', 5, 'LineWidth', 2);
plot(start_x, start_y, 'ms', 'MarkerSize', 8, 'LineWidth', 2);
saveas(fig, 'leaf_teeth_detection.png');  % Save as PNG
close(fig);

% ---------------- Plot Results for debug purposes ----------------

% Plot the distribution of distances with valley detection
% figure;
% plot(1:length(distances_smooth), distances_smooth, 'b', 'LineWidth', 1.5);
% hold on;
% plot(locs, distances_smooth(locs), 'ro', 'MarkerSize', 6, 'LineWidth', 2); % Mark valleys
% plot(1, distances_smooth(1), 'ms', 'MarkerSize', 8, 'LineWidth', 2); % Starting point
% xlabel('Boundary Point Index');
% ylabel('Distance to Convex Hull');
% title('Distance Distribution from Leaf Edge to Convex Hull (Valley Detection)');
% legend('Distance to Hull', 'Detected Valleys (Teeth Bases)', 'Starting Point');
% hold off;

% Plot the original leaf with detected valleys (tooth bases)
% figure;
% imshow(bw);
% hold on;
% plot(x, y, 'b', 'LineWidth', 1); % Leaf boundary
% plot(hull_x, hull_y, 'g-', 'LineWidth', 2); % Convex hull
% plot(x(locs), y(locs), 'ro', 'MarkerSize', 5, 'LineWidth', 2); % Mark detected valleys
% plot(start_x, start_y, 'ms', 'MarkerSize', 8, 'LineWidth', 2); % Starting point
% title(['Number of Leaf Teeth Detected: ', num2str(length(valleys))]);
% legend('Leaf Boundary', 'Convex Hull', 'Teeth Bases (Valleys)', 'Starting Point');
% hold off;


