                              R E A D M E
                          ======================
                   Liming Cai (daybreak.chua@gmail.com)

These MatLab codes are intended to process RGB images of leaf to extract their outline and analyse it using EFD.

# I. Segment leaf outline from images

If using herbarium specimen image, use `specimen_img_trace_to_individual_bw_mask.m` to segment individual leaves.
If using stained leaves, use `cleared_leaf_image_segmentation.m` to convert images to binary masks.

# II. Rotate the black-white mask to get dimension measurements

1. Place all images in a folder and call the function `batch_rotate_images('folder')` to interactively define the y axis of the image.

2. Then call function `dimention_measurement` to obtain aspect ratio and area for each leaf
```
image_files = dir(fullfile(folder_path, 'rotate*.png'));
leaf_dim = ["ID" "width" "length" "area"];
for i = 1:numel(image_files)
    img = imread(fullfile(folder_path, image_files(i).name));
	[width len area]=dimention_measurement(img);
	sp=string(image_files(i).name);
	new_row = [sp string(width) string(len) string(area)]
	leaf_dim = vertcat(leaf_dim, new_row)
end

%output to csv
filename = 'leaf_dimention.csv';
writematrix(leaf_dim, filename);
```
# III. EFD analysis
EFD_main.m to get EFD coefficient for PCA analysis.                            
                            
                            
==================================================
Below is the readme file from the original contributor who wrote the EFD analysis                            
                            Auralius Manurung
                           auralius@lavabit.com

1) plot_chain_code(ai, color, line_width)
-----------------------------------------
This function will plot the given chain code. The chain code (ai) should be in 
column vector.
Example:
>> ai = [5 4 1 2 3 4 3 0 0 1 0 1 0 0 0 7 7 1 1 0 7 5 4 5 4 5 0 6 5 4 1 3 4 4 ...
         4 4 6];
>> plot (ai)


2) plot_fourier_approx(ai, n, m, normalized, color, line_width)
---------------------------------------------------------------
This function will plot the fourier approximation, given a chain code (ai), 
number of harmonic elements (n), and number of points for reconstruction (m). 
Normalization can be applied by setting "normalized = 1".


3) output = calc_traversal_dist(ai, n, m, normalized)
------------------------------------------------
This function will generate position coordinates of chain code (ai). Number of 
harmonic elements (n), and number of points for reconstruction (m) must be 
specified.  
The output is a matrix of [x1, y1; x2, y2; ...; xm, ym].


3) output = fourier_approx(ai, n, m, normalized)
------------------------------------------------
This function will generate position coordinates of fourier approximation of 
chain code (ai).Number of harmonic elements (n), and number of points for 
reconstruction (m) must be specified.
The output is a matrix of [x1, y1; x2, y2; ...; xm, ym].


4) output = calc_harmonic_coefficients(ai, n)
---------------------------------------------
This function will calculate the n-th set of four harmonic coefficients.
The output is [an bn cn dn]


5) [A0, C0] = calc_dc_components(ai)
------------------------------------
Ths function will calculate the bias coefficients A0 and C0.
A0 and C0 are bias coefficeis, corresponding to a frequency of zero.


6) output = calc_traversal_dist(ai)
-----------------------------------
Traversal distance is defined as accumulated distance travelled by every 
component of the chain code assuming [0 0] is the starting position.
Example:
>> x = calc_traversal_dist([1 2 3])
x = 
    1  1
    1  2
    0  3


7) output = calc_traversal_time(ai)
-----------------------------------
Traversal time is defined as accumulated time consumed by every 
component of the chain code.
Example:
>> x = calc_traversal_time([1 2 3])
x =

   1.4142
   2.4142
   3.8284
