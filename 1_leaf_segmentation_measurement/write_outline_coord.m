function write_outline_coord()
	% output outline coordinates for EFD analysis
	[rows, cols] = find(crop_rotatedLeafBw, 1);
	startPoint = [rows(1), cols(1)];
	% Trace boundary clockwise
	boundary = bwtraceboundary(crop_rotatedLeafBw, startPoint, 'n');
	fileID = fopen(fullfile(folder_path, [image_files(i).name,'_outline.tsv']),'w');
	dlmwrite(fullfile(folder_path, [image_files(i).name,'_outline.tsv']), boundary, 'delimiter', '\t');
	% Close file
	fclose(fileID);
	