function maxWidth = get_linear_width(mask, skeleton)
    % Get the size of the image
    [rows, cols] = size(mask);
    
    % Extract skeleton points
    [yS, xS] = find(skeleton);
    
    % Initialize list to store width values
    widthList = zeros(length(yS), 1);
    
    % Compute gradient to estimate the perpendicular direction
    [Gx, Gy] = gradient(double(skeleton));
    
    % Iterate through each skeleton point
    for i = 1:length(yS)
        % Get the current skeleton point
        x0 = xS(i);
        y0 = yS(i);

        % Get local gradient at the current point
        if (y0 > 1 && y0 < rows && x0 > 1 && x0 < cols)
            dx = Gx(y0, x0);
            dy = Gy(y0, x0);
        else
            dx = 0;
            dy = 1; % Default to vertical if at boundary
        end
        
        % Normalize gradient vector to get perpendicular direction
        normal = [-dy, dx];
        norm_factor = norm(normal);
        
        if norm_factor == 0
            widthList(i) = 0; % Skip points where normal is undefined
            continue;
        end
        
        normal = normal / norm_factor;

        % Search outward from skeleton point in both normal directions
        width = 0;
        for direction = [-1, 1]
            step = 0;
            while true
                step = step + 1;
                
                % Compute new position
                xTest = round(x0 + direction * step * normal(1));
                yTest = round(y0 + direction * step * normal(2));
                
                % Check if the new position is within image bounds
                if xTest < 1 || xTest > cols || yTest < 1 || yTest > rows
                    break;
                end
                
                % Stop when hitting background (zero in mask)
                if mask(yTest, xTest) == 0
                    break;
                end
            end
            width = width + step; % Add the distance to the boundary
        end
        
        % Store the width at the current skeleton point
        widthList(i) = width;
    end
    maxWidth = max(widthList);
    width_bbx = get_width(mask);
    if maxWidth > 2 * width_bbx
    	maxWidth = width_bbx
    end
end
