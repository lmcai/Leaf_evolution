function batch_rotate_images(folder_path)
% Batch rotate images in a folder based on user-defined vertical direction

% List all image files in the folder
image_files = dir(fullfile(folder_path, '*.png'));

% Loop through all image files
for i = 1:length(image_files)
    
    % Read in the image
    img = imread(fullfile(folder_path, image_files(i).name));
    
    % Display the image
    imshow(img);
    
    % Prompt the user to select two points to define the rotation angle
    disp(['Image ', num2str(i), ': Select two points to define the rotation angle']);
    [x,y] = ginput(2);
    
    % Compute the angle of rotation
    angle = atan2(y(2) - y(1), x(2) - x(1)) * 180 / pi + 90;
    
    % Rotate the image
    rotated_img = imrotate(img, angle, 'crop');
    
    % Save the rotated image
    imwrite(rotated_img, fullfile(folder_path, ['rotated_', image_files(i).name]));
    
    % Close the current figure
    close;
    
end