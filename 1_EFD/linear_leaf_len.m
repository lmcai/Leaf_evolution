bw=imread('Orthocarpus_tolmiei_NoelHHolmgren16694_12.03ppm.bw.2.png');
bw=imfill(bw,'holes');
stats = regionprops('table', bw, 'BoundingBox');
bbox = stats.BoundingBox(1, :);
cropped_img = imcrop(bw, bbox);
imshow(skeleton(cropped_img)>20);