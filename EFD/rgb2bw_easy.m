function BW = rgb2bw_easy(img)
	% Convert the image to grayscale
	grayImg = rgb2gray(img);
	grayImg = imadjust(grayImg);
	F = fspecial("average",3);
	grayImg = imfilter(grayImg,F,'replicate');
	% Threshold the image to create a binary mask
	mask = imbinarize(grayImg);
	% Fill holes in the mask
	mask = ~mask;
	BW = imfill(mask, 'holes');
	BW = bwareafilt(BW, 1);
end
