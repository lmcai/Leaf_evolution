function d = point_to_line_segment_distance(px, py, x1, y1, x2, y2)
    % Compute the squared length of the segment
    seg_length_sq = (x2 - x1)^2 + (y2 - y1)^2;
    
    if seg_length_sq == 0
        % If the segment is a single point, return Euclidean distance
        d = sqrt((px - x1)^2 + (py - y1)^2);
        return;
    end
    
    % Compute projection factor t
    t = ((px - x1) * (x2 - x1) + (py - y1) * (y2 - y1)) / seg_length_sq;
    
    % Clamp t to the segment range [0,1]
    t = max(0, min(1, t));
    
    % Compute the closest point on the segment
    closest_x = x1 + t * (x2 - x1);
    closest_y = y1 + t * (y2 - y1);
    
    % Compute the Euclidean distance to the closest point
    d = sqrt((px - closest_x)^2 + (py - closest_y)^2);
end