function boundary=write_outline_coord(img)
	% output outline coordinates for EFD analysis
	[rows, cols] = find(img, 1);
	startPoint = [rows(1), cols(1)];
	% Trace boundary clockwise
	boundary = bwtraceboundary(img, startPoint, 'n');

	