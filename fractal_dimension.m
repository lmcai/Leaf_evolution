function fractalDimension = fractal_dimension(contour)
	% Convert the contour to a binary image
	binaryImage = imread(contour);
	
	% Set the range of grid sizes to use
	maxBoxSize = min(size(binaryImage));
	%minBoxSize = fix(maxBoxSize/128);

	% Initialize arrays to store the number of boxes and box sizes
	numBoxes = zeros(1, 50);
	boxSizes = zeros(1, 50);
	
	% Count the number of boxes that contain any part of the contour for each box size
	for i = 1:50
		boxlen=fix(maxBoxSize/i);
   		boxes = reshape(binaryImage(1:boxlen*floor(size(binaryImage,1)/boxlen),1:boxlen*floor(size(binaryImage,2)/boxlen)), boxlen, boxlen, []);
    	numBoxes(i) = sum(sum(any(any(boxes))));
    	boxSizes(i) = i;
	end
	%for i = 1:maxBoxSize
   	%	boxes = reshape(binaryImage(1:i*floor(size(binaryImage,1)/i),1:i*floor(size(binaryImage,2)/i)), i, i, []);
    %	numBoxes(i) = sum(sum(any(any(boxes))));
    %	boxSizes(i) = maxBoxSize/i;
	%end

	% Plot the results on a log-log plot
	loglog(boxSizes, numBoxes, 'o');
	xlabel('Box size');
	ylabel('Number of boxes');

	% Fit a line to the plot and calculate the fractal dimension
	p = polyfit(log10(boxSizes), log10(numBoxes), 1);
	fractalDimension = p(1);
