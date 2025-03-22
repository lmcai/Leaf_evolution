% Read the binary mask image
bw = imread('leaf_mask.png'); % Replace with your image filename
bw = im2bw(bw); % Ensure it is binary (if not already)

% Extract the leaf boundary
[B, ~] = bwboundaries(bw, 'noholes');

% Select the largest boundary (assuming the leaf is the largest object)
boundary = B{1};

% Extract x and y coordinates of the boundary
x = boundary(:,2);
y = boundary(:,1);

% Compute the Euclidean distance of each boundary point from the centroid
centroid = mean(boundary);
distances = sqrt((x - centroid(1)).^2 + (y - centroid(2)).^2);

% Smooth the distance signal to reduce noise
distances_smooth = smooth(distances, 2); 

% Find peaks in the distance signal (corresponding to teeth)
[peaks, locs] = findpeaks(distances_smooth, 'MinPeakProminence', 5);

% Display the results
figure;
imshow(bw);
hold on;
plot(x(locs), y(locs), 'ro', 'MarkerSize', 5, 'LineWidth', 2); % Mark detected teeth
title(['Number of Leaf Teeth: ', num2str(length(peaks))]);
hold off;

% Print the count of leaf teeth
fprintf('Number of leaf teeth detected: %d\n', length(peaks));
