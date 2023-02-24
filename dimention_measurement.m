% Load the binary image containing the segregated object
binary_image = imread('segregated_object.png');

% Calculate the connected components in the binary image
cc = bwconncomp(binary_image);

% Calculate the properties of the connected components
props = regionprops(cc, 'BoundingBox', 'Area');

% Extract the dimensions and area of the first connected component (assuming there's only one)
bbox = props(1).BoundingBox;
width = bbox(3);
height = bbox(4);
area = props(1).Area;

% Print the dimensions and area
fprintf('Width: %d\nHeight: %d\nArea: %d\n', width, height, area);