function [axis_path linear_length]=get_linear_length(im)

% Skeletonization
skeleton = bwmorph(im, 'thin', Inf);
totalLength = sum(skeleton(:)); 

% Identify endpoints
endPoints = bwmorph(skeleton, 'endpoints');
[yE, xE] = find(endPoints);  % Get coordinates of endpoints

% Initialize longest geodesic distance
maxDist = 0;
longestPair = [];

% Compute geodesic distances for all pairs of endpoints
for i = 1:length(xE)
    for j = i+1:length(xE) % Avoid redundant pairs
        distMap = bwdistgeodesic(skeleton, xE(i), yE(i), 'quasi-euclidean');
        distance = distMap(yE(j), xE(j)); % Distance to endpoint j
        
        % Update longest pair if new max distance found
        if distance > maxDist
            maxDist = distance;
            longestPair = [i, j]; % Store indices of endpoints
        end
    end
end

% Extract the two endpoints with longest geodesic distance
p1 = [xE(longestPair(1)), yE(longestPair(1))];
p2 = [xE(longestPair(2)), yE(longestPair(2))];

% Compute the shortest pixel path between them
D = bwdistgeodesic(skeleton, p1(1), p1(2), 'quasi-euclidean');
shortestPath = false(size(skeleton));
pathLength = 0;

if ~isnan(D(p2(2), p2(1))) % Ensure a valid path exists
    % Trace the shortest path pixel by pixel
    currentPoint = p2;
    while ~isequal(currentPoint, p1)
        shortestPath(currentPoint(2), currentPoint(1)) = 1;
        pathLength = pathLength + 1;

        % Find neighboring pixels with decreasing distance
        [yN, xN] = find(imdilate(shortestPath, ones(3)) & skeleton);
        validNeighbors = arrayfun(@(k) D(yN(k), xN(k)), 1:length(xN));
        
        % Move to the next pixel in the shortest path
        [~, minIdx] = min(validNeighbors);
        currentPoint = [xN(minIdx), yN(minIdx)];
    end
end

axis_path = shortestPath;
linear_length = pathLength; 
% linear_length = maxDist;