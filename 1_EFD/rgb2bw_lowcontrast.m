function BW = rgb2bw_lowcontrast(img)
	% Convert the image to grayscale
	grayImg = rgb2gray(img);
	grayImg = imadjust(grayImg);
	F = fspecial("average",3);
	grayImg = imfilter(grayImg,F,'replicate');
	igrayImg=medfilt2(grayImg,[5 5]);
	% Threshold the image to create a binary mask
	mask = imbinarize(grayImg);
	% Fill holes in the mask
	mask = ~mask;
	mask = imclearborder(mask);
	filledMask = imfill(mask, 'holes');
	SE = strel("disk",5);
	filledMask = imclose(filledMask,SE);
	%remove small objects and touching boarder
	filledMask = imclearborder(filledMask);
	filledMask=bwareaopen(filledMask, 10000);
	% Retain only one biggest object from the mask
	BW = bwareafilt(filledMask, 1);
	BW = imfill(BW, 'holes');
	%remove marginal hair or other artifacts
	BW = ~BW;
	BW = imclose(BW,SE);
	BW = ~BW;
	BW = bwareafilt(BW, 1);
end