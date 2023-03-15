function maxRowWidth=get_width(im)
	% Get number of rows and columns
	[rows, columns] = size(im);
	% Initialize arrays to hold the indices of the first and last non-zero pixels in each row
	firstNonZero = zeros(rows, 1);
	lastNonZero = zeros(rows, 1);
	% Initialize a variable to hold the maximum row width and its index
	maxRowWidth = 0;
	maxRowIndex = 0;

	% Iterate through each row of the image
	for i = 1:rows
    	% Find the indices of the non-zero pixels in the current row
    	nonZeroIndices = find(im(i, :) ~= 0);
    	% Check if there are any non-zero pixels in the current row
    	if ~isempty(nonZeroIndices)
        	% Set the index of the first non-zero pixel in the current row
        	firstNonZero(i) = nonZeroIndices(1);
        	% Set the index of the last non-zero pixel in the current row
        	lastNonZero(i) = nonZeroIndices(end);
    		rowWidth = nonZeroIndices(end)-nonZeroIndices(1)+1;
    		if rowWidth > maxRowWidth
        		% Update the maximum row width and its index
        		maxRowWidth = rowWidth;
        		maxRowIndex = i;
    		end
    	end
	end
