function batch_rotate_images_manual(folder_path)
% Batch rotate images in a folder based on user-defined vertical direction

% List all image files in the folder
	image_files = dir(fullfile(folder_path, '*.bw.png'));
	% Loop through all image files
	for i = 1:length(image_files)
    
    % Read in the image
    %image_files(i).name
    img = imread(fullfile(folder_path, image_files(i).name));
    if ndims(img)==3
    	img = rgb2gray(img);
    	img = imbinarize(img);
    end
    if isa(img, 'uint8')
    	img=imbinarize(img);
    end
    img = imfill(img,"holes");
    img = bwareafilt(img, 1);
    gaussianFilter = fspecial('gaussian', [5 5], 1);
	img = imfilter(img, gaussianFilter);
	% Display the image
    figure;
    imshow(img);
    % Prompt the user to select two points to define the rotation angle
    title(['Image ', image_files(i).name, ': Select two points to define the rotation angle']);
    hold on;
    [x,y] = ginput(2);
    % Compute the angle of rotation
    angle = atan2(y(2) - y(1), x(2) - x(1)) * 180 / pi - 90;
    % Rotate the image
    rotatedLeafBw = imrotate(img, angle);
    % crop image based on bounding box
	stats = regionprops(rotatedLeafBw, 'BoundingBox');
	boundingBox = stats.BoundingBox;
	% Calculate new size
	newWidth = boundingBox(3) * 2;
	newHeight = boundingBox(4) * 2;
	% Calculate upper-left corner of new crop
	centerX = boundingBox(1) + boundingBox(3) / 2;
	centerY = boundingBox(2) + boundingBox(4) / 2;
	newX = centerX - newWidth / 2;
	newY = centerY - newHeight / 2;
	
	% Crop binary image
	crop_rotatedLeafBw = imcrop(rotatedLeafBw, [newX, newY, newWidth, newHeight]);
    % Save the rotated image
    imwrite(crop_rotatedLeafBw, fullfile(folder_path, ['rotated_', image_files(i).name]));
	
    % Close the current figure
    close;
end