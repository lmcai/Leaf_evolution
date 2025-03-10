function smoothedBW = smoothPixelPositions(BW)
    % Get the boundary of the object
    boundary = bwperim(BW);
    [rows, cols] = size(BW);
    
    % Define neighborhood offsets (8-connectivity)
    offsets = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];
    
    % Copy input image for updating
    updatedBW = BW;
    
    % Iterate over boundary pixels
    [y, x] = find(boundary);
    for i = 1:length(y)
        px = x(i);
        py = y(i);
        
        % Get local neighborhood (within 1-pixel movement range)
        neighbors = [];
        for j = 1:size(offsets, 1)
            nx = px + offsets(j, 2);
            ny = py + offsets(j, 1);
            
            if nx > 1 && nx < cols && ny > 1 && ny < rows
                if BW(ny, nx) == 1 % Consider only foreground pixels
                    neighbors = [neighbors; nx, ny];
                end
            end
        end
        
        % If there are at least 2 neighbors, find optimal move
        if size(neighbors, 1) >= 2
            avgX = round(mean(neighbors(:, 1)));
            avgY = round(mean(neighbors(:, 2)));
            
            % Move pixel to the optimal average position (within 1-pixel limit)
            if abs(avgX - px) <= 1 && abs(avgY - py) <= 1
                updatedBW(py, px) = 0; % Remove from old position
                updatedBW(avgY, avgX) = 1; % Move to new position
            end
        end
    end
    
    % Return the updated binary mask
    smoothedBW = updatedBW;
end
