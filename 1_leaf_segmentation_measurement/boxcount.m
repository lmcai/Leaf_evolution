function count = boxcount(binaryArray, boxSize)
% BOXCOUNT Count the number of boxes needed to cover a binary image for a given box size

% Compute the number of boxes in each direction
numBoxesX = floor(size(binaryArray, 2) / boxSize);
numBoxesY = floor(size(binaryArray, 1) / boxSize);

% Initialize the count to zero
count = 0;

% Check each box to see if it contains any foreground pixels
for i = 1:numBoxesY
    for j = 1:numBoxesX
        box = binaryArray((i-1)*boxSize+1:i*boxSize, (j-1)*boxSize+1:j*boxSize);
        if any(box(:))
            count = count + 1;
        end
    end
end