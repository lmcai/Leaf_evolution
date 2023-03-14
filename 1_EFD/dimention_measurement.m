function [width length total_area]=dimention_measurement(im)
	stats = regionprops(im, 'BoundingBox');
	width = stats.BoundingBox(3);
	length = stats.BoundingBox(4);
	% Calculate the connected components in the binary image
	cc = bwconncomp(im);
	% Calculate the region properties for each connected component
	props = regionprops(cc, 'Area');
	% Compute the total area of all objects in the image
	total_area = sum([props.Area]);

