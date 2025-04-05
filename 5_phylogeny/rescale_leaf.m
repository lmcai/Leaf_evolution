% Load CSV file
data = readtable('image_scale.csv');  % Replace with your actual CSV file name

% Pixel density
pixelsPerMM = 6;

% Process each image
for i = 1:height(data)
    filename = data{i, 1}{1};  % Image file name
    current_scale = data{i, 2};  % Object length in mm
	
	if ~isfile(filename)
        fprintf('File not found: %s. Skipping.\n', filename);
        continue;
    end
    
    % Read and convert image
    img = imread(filename);
    bw = img;
    if size(img, 3) > 1
        img = rgb2gray(img);
        bw = imbinarize(img);
    end

    % Retain only the largest object
    bw = bwareafilt(bw, 1);

    % Compute scaling factor
    scaleFactor = pixelsPerMM/current_scale;
    
    %props = regionprops(bw, 'BoundingBox');
    %bbox = round(props.BoundingBox);
    %cropped = imcrop(bw, bbox);

    % Resize image
    resized = imresize(bw, scaleFactor, 'nearest');

    % Reverse black and white
    reversed = ~resized;

    % Generate output file name
    %[filepath, name, ~] = fileparts(filename);
    %outputName = fullfile(filepath, [name, '_rescaled.png']);
    % Save the image
    %imwrite(reversed, outputName);
    %fprintf('Processed: %s -> %s\n', filename, outputName);
    
    %%%%%%%%%%
    boundaries = bwboundaries(resized, 'noholes');

% Generate output file name
[filepath, name, ~] = fileparts(filename);
outputName = fullfile(filepath, [name, '_vectorized.svg']);

% Create transparent figure
fig = figure('Visible', 'off', 'Color', 'none');
ax = axes('Parent', fig, 'Color', 'none');
axis equal off
hold on

% Plot the object as a smooth filled patch
for k = 1:length(boundaries)
    boundary = boundaries{k};
    % Smooth the edges using spline interpolation
    t = 1:length(boundary);
    ts = linspace(1, length(boundary), 10 * length(boundary));  % 10x smoothing
    xs = spline(t, boundary(:,2), ts);
    ys = spline(t, boundary(:,1), ts);
    
    patch(xs, ys, 'k', 'EdgeColor', 'none', 'FaceColor', 'black');  % Fill with black
end

% Save as SVG (vector paths)
print(fig, outputName, '-dsvg');

% Close figure
close(fig);
    fprintf('Processed: %s -> %s\n', filename, outputName);
    
end
