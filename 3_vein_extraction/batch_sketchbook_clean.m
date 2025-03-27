function batch_sketchbook_clean(folder_path)
% get names of all images files
image_files = dir(fullfile(folder_path, '*traced.png'));
for i = 1:numel(image_files)
	% Read the PNG image
	img = imread(fullfile(folder_path, image_files(i).name));

	% Filter red and color
	red_indices = img(:,:,1) > 200 & img(:,:,2) < 50 & img(:,:,3) < 50;
	yellow_indices = img(:,:,1) > 220 & img(:,:,2) > 200 & img(:,:,3) < 20;

	se = strel('diamond', 3);
	% red_mask=imopen(red_indices,se);
	yellow_mask=imopen(yellow_indices,se);
	yellow_mask=imclose(yellow_indices,se);

	red_mask = red_indices > 0;
	yellow_mask = yellow_indices > 0;
	%yellow_mask=bwareafilt(yellow_mask,1);

	% Create a white background image
	%white_bg = uint8(ones(size(red_mask)) * 255);

	% Find the overlapping region and exclude it from the yellow mask
	overlap_region = red_mask & yellow_mask;
	yellow_mask(overlap_region) = 0;
	red_mask(overlap_region) = 1;

	% Fill gap with red
	redyellow_mask= red_mask + yellow_mask;
	filled_redyellow_mask=imfill(redyellow_mask,'holes');
	%se = strel('diamond', 2);
	%filled_redyellow_mask=imclose(redyellow_mask,se);
	gap=filled_redyellow_mask & ~redyellow_mask;
	red_mask(gap)=1;

	% Assign red pixels where red_mask is true
	output_img = cat(3, red_mask * 255, zeros(size(red_mask)), zeros(size(red_mask)));

	% Assign yellow pixels where yellow_mask is true and not overlapping with red
	output_img(:,:,1) = output_img(:,:,1) + yellow_mask * 255;
	output_img(:,:,2) = output_img(:,:,2) + yellow_mask * 255;

	% Display the output image
	imshow(output_img);
	imwrite(output_img, fullfile(folder_path, [strtok(image_files(i).name, '.'),'.clean.png']));
end



