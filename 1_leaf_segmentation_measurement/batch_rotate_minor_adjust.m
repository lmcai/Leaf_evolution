function batch_rotate_minor_adjust(folder_path)
% Batch rotate images in a folder to align the longest axis vertically
% Rotation is restricted to ±45 degrees to avoid excessive transformations

% List all image files in the folder
image_files = dir(fullfile(folder_path, '*bw.png'));

% Loop through all image files
for i = 1:length(image_files)
    disp(['Processing: ', image_files(i).name]); % Display current file
    
    % Read in the image
    img = imread(fullfile(folder_path, image_files(i).name));
    
    % Convert to binary if necessary
    if ndims(img) == 3
        img = rgb2gray(img);
    end
    if isa(img, 'uint8')
        img = imbinarize(img);
    end
    
    % Keep only the largest connected component
    img = bwareafilt(img, 1);
    
    % Get orientation using Eigenvectors
    theta_longaxis = getLongestAxisAngle(img);
    
    % Restrict rotation to ±45 degrees
    if theta_longaxis > 45
        theta_longaxis = theta_longaxis - 90;
    elseif theta_longaxis < -45
        theta_longaxis = theta_longaxis + 90;
    end
    
    % Rotate image
    rotatedLeafBw = imrotate(img, -theta_longaxis, 'bilinear', 'crop');
    
    % Crop image based on bounding box
    stats = regionprops(rotatedLeafBw, 'BoundingBox');
    boundingBox = stats.BoundingBox;
    
    % Define new cropping size (expand slightly for safety)
    expansionFactor = 1.2; % Expand by 20% for better coverage
    newWidth = boundingBox(3) * expansionFactor;
    newHeight = boundingBox(4) * expansionFactor;
    
    % Calculate new crop position
    centerX = boundingBox(1) + boundingBox(3) / 2;
    centerY = boundingBox(2) + boundingBox(4) / 2;
    newX = centerX - newWidth / 2;
    newY = centerY - newHeight / 2;
    
    % Crop rotated image
    crop_rotatedLeafBw = imcrop(rotatedLeafBw, [newX, newY, newWidth, newHeight]);
    
    % Smooth outline using Gaussian filter
    gaussianFilter = fspecial('gaussian', [5 5], 1);
    crop_rotatedLeafBw = imfilter(crop_rotatedLeafBw, gaussianFilter);
    
    % Save the rotated image
    imwrite(crop_rotatedLeafBw, fullfile(folder_path, ['rotated_', image_files(i).name]));
end
end

% **Helper Function to Compute Longest Axis Angle**
function theta = getLongestAxisAngle(img)
    % Compute the coordinates of the foreground pixels
    [y, x] = find(img);
    
    % Center the coordinates
    x = x - mean(x);
    y = y - mean(y);
    
    % Perform Principal Component Analysis (PCA)
    covarianceMatrix = cov(x, y);
    [eigenvectors, ~] = eig(covarianceMatrix);
    
    % Extract the longest axis orientation
    longestAxisVector = eigenvectors(:, 2);
    
    % Compute the angle in degrees
    theta = atan2d(longestAxisVector(2), longestAxisVector(1));
end
