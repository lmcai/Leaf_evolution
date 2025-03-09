function [width width_bbx length_bbx total_area solidity circularity EI]=dimension_measurement(im)
	stats = regionprops(im, 'BoundingBox');
	width = get_width(im);
	skeleton=bwmorph(BW,'thin',5);
	
	length_bbx = ;
	width_bbx = stats(1).BoundingBox(3);
	% Calculate the connected components in the binary image
	cc = bwconncomp(im);
	% Calculate the region properties for each connected component
	props = regionprops(cc, 'Area');
	% Compute the total area of all objects in the image
	total_area = sum([props.Area]);
		
	%solidity=area/convex_hull
	convexHull = bwconvhull(im);
	% Compute area of convex hull
	cvHull_props = regionprops(convexHull, 'Area');
	cvHull_Area = cvHull_props.Area;
	solidity = total_area/cvHull_Area;
	
	% circularity = 4 * pi * area/parimeter^2
	% Use the built-in circularity function of the image processing toolbox
	%perimeter = bwperim(im);
	% Count number of perimeter pixels
	%numPerimeterPixels = sum(perimeter(:));
	%circularity = (4 * pi * total_area)/(numPerimeterPixels * numPerimeterPixels)
	%circularity = regionprops(im,"Circularity");
	%circularity = circularity.Circularity;
	
	perimpix = abs(conv2(im,[1 -1],'same')) | abs(conv2(im,[1;-1],'same'));
	[Ip,Jp] = find(perimpix);
	% use a convexhull to generate a polygonal perimeter
	edgelist = convhull(Ip,Jp);
	polyperim = sum(sqrt(diff(Ip(edgelist)).^2 + diff(Jp(edgelist)).^2));
	circularity = 4*pi*sum(im(:))/polyperim.^2;
	%See also https://www.mathworks.com/matlabcentral/answers/442374-how-to-detect-circularity-more-accurately-than-4-pi-a-p-2#answer_1198565
	
	%EI = 4 A/(πLW)
	EI = (4*total_area)/(pi*length_bbx*width);
