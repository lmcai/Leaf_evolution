function batch_dimension_measurement(folder_path)
% Batch measures the leaf dimensions and areas, output to a csv file named 'leaf_dimention.csv'
image_files = dir(fullfile(folder_path, 'rotated_*bw.png'));
leaf_dim = ["ID" "width" "width_bbx" "length_bbx" "area" "Solidity" "Circularity" "Ellipticalness_Index" "teeth_number"];
for i = 1:numel(image_files)
	image_files(i).name
    img = imread(fullfile(folder_path, image_files(i).name));
    if ndims(img)==3
    	img = rgb2gray(img);
    	img = imbinarize(img);
    	% img = imfill(img,'holes');
    	img = bwareafilt(img,1);
    end
    %measure dimensions
	[width width_bbx len_bbx area solidity circularity EI teeth]=dimension_measurement(img,image_files(i).name);
	new_row = [string(image_files(i).name) string(width) string(width_bbx) string(len_bbx) string(area) string(solidity) string(circularity) string(EI) string(teeth)];
	leaf_dim = vertcat(leaf_dim, new_row);
	
	%write coordinates
	coords=write_outline_coord(img);
	fileID = fopen(fullfile(folder_path, [image_files(i).name,'_outline.tsv']),'w');
	dlmwrite(fullfile(folder_path, [image_files(i).name,'_outline.tsv']), coords, 'delimiter', '\t');
	fclose(fileID);
end

%output measurements to csv
filename = 'leaf_dimension.csv';
writematrix(leaf_dim, filename);
