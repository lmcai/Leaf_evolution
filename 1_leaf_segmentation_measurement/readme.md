                              R E A D M E
                          ======================
                   Liming Cai (daybreak.chua@gmail.com)

These MatLab codes are intended to process RGB images of leaf to extract their outline and analyse it using EFD.

# I. Segment leaf outline from images

If using herbarium specimen image, use `specimen_img_trace_to_individual_bw_mask.m` to segment individual leaves.
If using stained leaves, use `cleared_leaf_image_segmentation.m` to convert images to binary masks.

# II. Rotate the black-white mask to get dimension measurements

1. Place all images in a folder and call the function `batch_rotate_images(folder_path)` to rotate image. This function will write a rotated image `rotated_*` to the folder 

This should generate one png file `rotated_*.png` per image where the main axis is placed vertically.

2. Manual inspect the rotated leaves, heart shaped can be tricky. Place these leaves need to be manually rotated in one folder and use `batch_rotate_images_manual(folder_path)` 

This should generate a png file `rotated_*.png` where the main axis is placed vertically

3. Some images are upside down, they need to be manually sorted into one folder and use the following script to rotate the image.
```
image_files = dir(fullfile(folder_path, 'rotate*.png'));
for i = 1:numel(image_files)
	img = imread(fullfile(folder_path, image_files(i).name));
	% Rotate the image 180 degrees
	rotated_img = imrotate(img, 180, 'bilinear');
	imwrite(rotated_img,fullfile(folder_path, image_files(i).name))
```

4. Once satisfied with the orientation of the leaf images, measure the dimension of the leaves with the following code. This should 
```
image_files = dir(fullfile(folder_path, 'rotate*.png'));
leaf_dim = ["ID" "width" "width_bbx" "length" "area"];
for i = 1:numel(image_files)
    img = imread(fullfile(folder_path, image_files(i).name));
	[width width_bbx len area]=dimention_measurement(img);
	new_row = [string(image_files(i).name) string(width) string(width_bbx) string(len) string(area)]
	leaf_dim = vertcat(leaf_dim, new_row)
end

%output to csv
filename = 'leaf_dimention.csv';
writematrix(leaf_dim, filename);
```
# III. Fractal dimension as a measurement of leaf dissection

Use the function `fractal_dimension` to calculate a value for each individual leaf image.
```
folder_path = '/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/022323/';
image_files = dir(fullfile(folder_path, 'rotate*.png'));
leaf_fd = ["ID" "fd"];
for i = 1:numel(image_files)
	curr_fd=fractal_dimension(fullfile(folder_path, image_files(i).name));
	leaf_fd = vertcat(leaf_fd, [image_files(i).name string(curr_fd)]);
end

filename = 'leaf_fractal_dimention.csv';
writematrix(leaf_fd, filename);

```

# IV. EFD analysis
EFD_main.m to get EFD coefficient for PCA analysis.                            


