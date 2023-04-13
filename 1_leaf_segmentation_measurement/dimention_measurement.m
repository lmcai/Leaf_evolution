function [width width_bbx length_linear length_bbx total_area solidity circularity]=dimention_measurement(im)
	stats = regionprops(im, 'BoundingBox');
	width = get_width(im);
	length_linear = linear_leaf_len(im);
	width_bbx = stats(1).BoundingBox(3);
	length_bbx = stats(1).BoundingBox(4);
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
	solidity = total_area/cvHull_Area
	
	% circularity = 4 * pi * area/parimeter^2
	perimeter = bwperim(im);
	% Count number of perimeter pixels
	numPerimeterPixels = sum(perimeter(:));
	circularity = (4 * 3.1416 * total_area)/(numPerimeterPixels * numPerimeterPixels)
	
	%LeafBwStats = regionprops(rotatedLeafBw,'all');
	%[RDMX,RDMY,RCMX,RCMY,RDNX,RDNY,RCNX,RCNY] = CalcAxis(LeafBwStats);
	%tabledatarotated = regionprops('Table',rotatedLeafBw, 'Centroid',...
    %'Orientation', 'MajorAxisLength', 'MinorAxisLength','FilledArea',...
    %'BoundingBox');
    %length_pixel = tabledatarotated.BoundingBox(1,4);
    %width_pixel = tabledatarotated.BoundingBox(1,3);
    %area_pixel = LeafBwStats.Area;
    %visualization
    %rotateBWFig = figure('name','Analysis 2 of Selected Image');
    %imshow(rotatedLeafBw);
    %hold on, title('Rotated leaf BW with curves highlighted');
    %plot(imgca,LeafBwStats(1).Centroid(:,1),...
    %LeafBwStats(1).Centroid(:,2),'r*');
    %line(RCMX,RCMY);
    %line(RCNX,RCNY);
    %set(impixelinfo,'Position',[5, 1 300 20]);
    %plot(outlineLeaf(:,2),outlineLeaf(:,1),'r--','LineWidth',2.5);
    %plots the outline 
    %subplot(1,2,2),imshow(croppedscale,'InitialMagnification',100);