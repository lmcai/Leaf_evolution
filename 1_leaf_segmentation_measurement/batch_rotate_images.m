function batch_rotate_images(folder_path)
% Batch rotate images in a folder based on user-defined vertical direction

% List all image files in the folder
image_files = dir(fullfile(folder_path, '*.png'));
%leaf_dim = ["ID" "width" "length" "area"];
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

	imwrite(crop_rotatedLeafBw, fullfile(folder_path, ['rotated_', image_files(i).name]));
	
	% output outline coordinates for EFD analysis
	[rows, cols] = find(crop_rotatedLeafBw, 1);
	startPoint = [rows(1), cols(1)];
	% Trace boundary clockwise
	boundary = bwtraceboundary(crop_rotatedLeafBw, startPoint, 'n');
	fileID = fopen(fullfile(folder_path, [image_files(i).name,'_outline.tsv']),'w');
	dlmwrite(fullfile(folder_path, [image_files(i).name,'_outline.tsv']), boundary, 'delimiter', '\t');
	% Close file
	fclose(fileID);
end