function batch_rotate_images(folder_path)
% Batch rotate images in a folder based on user-defined vertical direction

% List all image files in the folder
image_files = dir(fullfile(folder_path, '*.png'));
leaf_dim = ["ID" "width" "length" "area"];
% Loop through all image files
for i = 1:length(image_files)
    
    % Read in the image
    img = imread(fullfile(folder_path, image_files(i).name));
    if ndims(img) == 3
    	img=rgb2gray(img);
    	img=imbinarize(img);
    	img=imfill(img,"holes");
    	img=bwareafilt(img,1);
    else
    	if isa(img, 'uint8')
    		img=imbinarize(img);
    		img=imfill(img,"holes");
    		img=bwareafilt(img,1);
   		end
    end
	% rotate img
    [theta_shortaxis,theta_longaxis] = Eigenvectors(img); 
	rotatedLeafBw = imrotate(img,(theta_longaxis + 90));
	rotatedLeafBw = imrotate(rotatedLeafBw, 180);
	imwrite(rotatedLeafBw, fullfile(folder_path, ['rotated_', image_files(i).name]));
end