function batch_specimen_leaf_segmentation(folder_path)
image_files = dir(fullfile(folder_path, '*.traced.png'));

for i = 1:numel(image_files)
    im = imread(fullfile(folder_path, image_files(i).name));
    % segment out yellow pixels with a broad 'yellow' spectrum to accommodate gradient colors
	BW = im(:,:,1) > 150 & im(:,:,2) > 150 & im(:,:,3) < 100;
	% remove small areas
	BW=bwareaopen(BW, 30);
	% smooth out edges with Gaussian Smoothing & Thresholding
	% BWSmooth = imgaussfilt(double(BW), 2); 
	% BWSmooth = BWSmooth > 0.5;
	% gaussianFilter = fspecial('gaussian', [5 5], 1);
	% im_gaus = imfilter(im, gaussianFilter);
	% BWSmooth = im(:,:,1) > 150 & im(:,:,2) > 150 & im(:,:,3) < 100;
	% se = strel('disk', 4);
	% BWSmooth = imclose(BW, se); % Close small holes
	% BWSmooth = imopen(BWSmooth, se);
	
	% close holes
	BW = imfill(BW, 'holes');
	[labeledMask, numObjects] = bwlabel(BW);
	%imshow(labeled,[])
	% Output individual leaf images
	prefix = split(image_files(i).name, ".");
	prefix = string(prefix(1));
	for i = 1:numObjects
		imwrite(labeledMask == i, join([folder_path,'/',prefix,'.bw.',num2str(i),'.png'],""));
	end
end

