img = imread('rgb_image.png');
%use color threshold app to segment and get BW

% remove small area
BW=bwareaopen(BW, 10000);

SE = strel("disk",5);
BW = imclose(BW,SE);
BW = imfill(BW, 'holes');

% set number of target segmentated object
n=15;
BW1 = bwareafilt(BW,n);
% Perform segmentation
labeled = bwlabel(BW);
% imshow(labeled,[])

% Output binary image of object to be saved
for i = 1:n
	imwrite(labeled == i, join(['Lindenbergia_philippensis_PraneePalee1266.bw.',num2str(i),'.png'],""));
end