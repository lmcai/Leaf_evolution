% Set the directory containing the images to crop
image_directory = 'path/to/images';

% Get a list of all image files in the directory
image_files = dir(fullfile(image_directory, '*.jpg'));

% Define the size of the cropped images
crop_size = [256, 256];

% Loop over all image files in the directory
for i = 1:length(image_files)
    
    % Read in the image
    image_path = fullfile(image_files(i).folder, image_files(i).name);
    image = imread(image_path);
    
    % Create a figure for displaying the image
    figure;
    imshow(image);
    
    % Use imrect to select the region to crop
    rect = imrect(gca, [0 0 crop_size(2) crop_size(1)]);
    
    % Wait for the user to finish adjusting the cropping rectangle
    wait(rect);
    
    % Get the position of the cropping rectangle
    rect_pos = round(getPosition(rect));
    
    % Crop the image using the rectangle position
    cropped_image = imcrop(image, rect_pos);
    
    % Save the cropped image to a new file
    [filepath, name, ext] = fileparts(image_path);
    cropped_file_path = fullfile(filepath, [name '_cropped' ext]);
    imwrite(cropped_image, cropped_file_path);
    
    % Close the figure
    close;
end