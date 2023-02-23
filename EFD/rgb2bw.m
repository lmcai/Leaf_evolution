% Load the PNG image
img = imread('image.png');

% Convert the image to grayscale
grayImg = rgb2gray(img);
grayImg = imadjust(grayImg);
F = fspecial("average",3);
grayImg = imfilter(grayImg,F,'replicate');

% Threshold the image to create a binary mask
mask = imbinarize(grayImg);

% Fill holes in the mask
mask = ~mask;
filledMask = imfill(mask, 'holes');
filledMask = ~filledMask;

% Retain only one biggest object from the mask
filteredMask = bwareafilt(filledMask, 1);
imwrite(filteredMask,'test_leaf.bw.png')

% Apply the mask to the original image
% maskedImg = bsxfun(@times, img, cast(filteredMask, 'like', img));

% Display the original and masked images side by side
% figure;
% subplot(1,2,1);
% imshow(img);
% title('Original Image');
% subplot(1,2,2);
% imshow(maskedImg);
% title('Masked Image');
