% Load the binary image containing the segregated object
im = imread('segregated_object.png');

% Calculate the connected components in the binary image
% cc = bwconncomp(im);

stats = regionprops(im, 'BoundingBox');
min_area = Inf;
for k = 1:length(stats)
    area = stats(k).BoundingBox(3) * stats(k).BoundingBox(4);
    if area < min_area
        min_area = area;
        min_box = stats(k).BoundingBox;
        dim1 = stats(k).BoundingBox(3);
		dim2 = stats(k).BoundingBox(3);
		width = min([dim1 dim2]);
		length = max([dim1 dim2]);
    end
end
imshow(im);
rectangle('Position', min_box, 'EdgeColor', 'r', 'LineWidth', 2);

%rotate Image
[grad_mag, grad_dir] = imgradient(im);
[H,theta,rho] = hough(grad_mag);
peaks = houghpeaks(H, 1);
angle = theta(peaks(2));
im_rotated = imrotate(im, -angle, 'bilinear', 'crop');
imshow(im_rotated);