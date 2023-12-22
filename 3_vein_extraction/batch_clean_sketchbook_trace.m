% Read the PNG image
img = imread('your_image.png');

% Filter red and color
red_indices = img(:,:,1) > 200 & img(:,:,2) < 20 & img(:,:,3) < 20;
yellow_indices = img(:,:,1) > 220 & img(:,:,2) > 200 & img(:,:,3) < 20;

se = strel('diamond', 3);
red_mask=imopen(red_indices,se);
yellow_mask=imopen(yellow_indices,se);
yellow_mask=imclose(yellow_indices,se);

red_mask = red_mask > 0;
yellow_mask = yellow_mask > 0;

% Create a white background image
%white_bg = uint8(ones(size(red_mask)) * 255);

% Assign red pixels where red_mask is true
output_img = cat(3, red_mask * 255, zeros(size(red_mask)), zeros(size(red_mask)));

% Find the overlapping region and exclude it from the yellow mask
%overlap_region = red_mask & yellow_mask;
%yellow_mask(overlap_region) = 0;

% Assign yellow pixels where yellow_mask is true and not overlapping with red
output_img(:,:,1) = output_img(:,:,1) + yellow_mask * 255;
output_img(:,:,2) = output_img(:,:,2) + yellow_mask * 255;

% Display the output image
imshow(output_img);



