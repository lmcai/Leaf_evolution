function batch_rotate_images_manual_specimen(folder_path)
% Batch rotate images in a folder based on user-defined vertical direction

% List all image files in the folder
image_files = dir(fullfile(folder_path, '*.bw.png'));

% Loop through all image files
for i = 1:length(image_files)
    
    % Read the BW mask
    img = imread(fullfile(folder_path, image_files(i).name));
    if ndims(img) == 3
        img = rgb2gray(img);
        img = imbinarize(img);
    end
    if isa(img, 'uint8')
        img = imbinarize(img);
    end
    
    % Keep only the largest connected component
    img = bwareafilt(img, 1);
    img = imfill(img, "holes");
    
    % Read the corresponding background image
    filename = split(image_files(i).name, '.');
    filename = string(filename(1));
    bg_img = imread(join([folder_path, filename, '.traced.png'], ''));
    bg_img = im2double(bg_img);
    
    % Get the bounding box of the BW mask
    stats = regionprops(img, 'BoundingBox');
    boundingBox = stats.BoundingBox;
    
    % Expand the bounding box by a factor of 3
    scaleFactor = 3;
    newWidth = boundingBox(3) * scaleFactor;
    newHeight = boundingBox(4) * scaleFactor;
    
    % Compute new upper-left corner
    centerX = boundingBox(1) + boundingBox(3) / 2;
    centerY = boundingBox(2) + boundingBox(4) / 2;
    newX = max(1, centerX - newWidth / 2);
    newY = max(1, centerY - newHeight / 2);
    
    % Ensure cropping does not exceed image boundaries
    newX = min(newX, size(bg_img,2) - newWidth);
    newY = min(newY, size(bg_img,1) - newHeight);
    newWidth = min(newWidth, size(bg_img,2) - newX);
    newHeight = min(newHeight, size(bg_img,1) - newY);
    
    % Crop the background image to the expanded region
    cropped_bg = imcrop(bg_img, [newX, newY, newWidth, newHeight]);
    
    % Crop the BW mask to match
    cropped_mask = imcrop(img, [newX, newY, newWidth, newHeight]);
    
    % Create a red overlay (for white mask areas)
    redOverlay = cat(3, ones(size(cropped_mask)), zeros(size(cropped_mask)), zeros(size(cropped_mask)));

    % Create final composite image
    finalImage = cropped_bg;
    alpha = 0.3; % Transparency level

    for c = 1:3
        finalImage(:,:,c) = finalImage(:,:,c) .* (1 - cropped_mask) + alpha * finalImage(:,:,c) .* (cropped_mask == 0);
    end

    % Apply solid red where the mask is white
    finalImage(repmat(cropped_mask, [1, 1, 3])) = redOverlay(repmat(cropped_mask, [1, 1, 3]));

    % Display the cropped final image
    figure;
    imshow(finalImage);
    title(['Image ', image_files(i).name, ': Select two points to define the rotation angle']);
    hold on;
    
    % User selects two points
    [x, y] = ginput(2);

    % Convert selected points to original coordinates
    x = x + newX;
    y = y + newY;

    % Compute the angle of rotation
    angle = atan2(y(2) - y(1), x(2) - x(1)) * 180 / pi - 90;

    % Rotate the BW mask
    rotatedLeafBw = imrotate(img, angle);

    % Get new bounding box after rotation
    stats = regionprops(rotatedLeafBw, 'BoundingBox');
    boundingBox = stats.BoundingBox;

    % Expand again by a factor of 3
    newWidth = boundingBox(3) * scaleFactor;
    newHeight = boundingBox(4) * scaleFactor;

    % Compute new crop position
    centerX = boundingBox(1) + boundingBox(3) / 2;
    centerY = boundingBox(2) + boundingBox(4) / 2;
    newX = max(1, centerX - newWidth / 2);
    newY = max(1, centerY - newHeight / 2);

    % Ensure new crop does not exceed image boundaries
    newX = min(newX, size(rotatedLeafBw,2) - newWidth);
    newY = min(newY, size(rotatedLeafBw,1) - newHeight);
    newWidth = min(newWidth, size(rotatedLeafBw,2) - newX);
    newHeight = min(newHeight, size(rotatedLeafBw,1) - newY);

    % Crop the rotated mask
    crop_rotatedLeafBw = imcrop(rotatedLeafBw, [newX, newY, newWidth, newHeight]);

    % Save the rotated and cropped image
    imwrite(crop_rotatedLeafBw, fullfile(folder_path, ['rotated_', image_files(i).name]));

    % Close figures
    close;
end
end
