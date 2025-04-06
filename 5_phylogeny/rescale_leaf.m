% Load CSV file
data = readtable('/Users/limingcai/Library/CloudStorage/Dropbox/Orobanchaceae_venation/Figures/Fig1_phylogeny/leaf_plotting_order.csv');

% Custom pixel density (pixels per mm)
pixelsPerMM = 6;

% Grid size for panel
gridRows = 5;
gridCols = 5;
panelSize = gridRows * gridCols;

% Initialize panel counter
panelIndex = 1;
tileIndex = 1;
tileImages = cell(panelSize, 1);
tileHeights = zeros(panelSize, 1);
tileWidths = zeros(panelSize, 1);

% Process each image
for i = 1:height(data)
    filename = data{i, 1}{1};
    current_scale = data{i, 4};

    if ~isfile(filename)
        fprintf('File not found: %s. Skipping.\n', filename);
        continue;
    end

    % Read and convert image
    img = imread(filename);
    if size(img, 3) > 1
        img = rgb2gray(img);
        bw = imbinarize(img);
    else
        bw = img;
    end

    % Keep only the largest object
    bw = bwareafilt(bw, 1);

    % Compute rescale factor
    scaleFactor = pixelsPerMM / current_scale;

    % Resize image and invert
    resized = imresize(bw, scaleFactor, 'nearest');
    reversed = ~resized;

    % Store for current panel
    tileImages{tileIndex} = reversed;
    [tileHeights(tileIndex), tileWidths(tileIndex)] = size(reversed);
    tileIndex = tileIndex + 1;
    fprintf('%s %d\n',filename, tileIndex);

    % When panel is full or last image reached
    if tileIndex > panelSize || i == height(data)
        % Determine max width/height for uniform tiles
        maxH = max(tileHeights(1:tileIndex-1));
        maxW = max(tileWidths(1:tileIndex-1));

        % Create blank white canvas for full panel
        panelImage = true(gridRows * maxH, gridCols * maxW);  % true = white

        for k = 1:tileIndex-1
            % Calculate row and column based on row-first filling order
            col =  mod(k-1, gridRows); % Then columns (left to right)
            row =  floor((k-1) / gridRows); % Rows first (top to bottom)            

            tile = tileImages{k};

            % Pad tile to match max size
            padTile = true(maxH, maxW);  % white background
            [h, w] = size(tile);
            padTile(1:h, 1:w) = tile;

            % Place tile into panel
            rStart = row * maxH + 1;
            cStart = col * maxW + 1;
            panelImage(rStart:rStart+maxH-1, cStart:cStart+maxW-1) = padTile;
        end

        % Add 20-pixel margin around the panel
        margin = 20;
        paddedPanel = true(size(panelImage) + 2 * margin);  % all white
        paddedPanel(margin+1:end-margin, margin+1:end-margin) = panelImage;

        % Output file name
        outName = sprintf('panel_%02d.png', panelIndex);

        % Reverse: object = black, background = white
        imwrite(paddedPanel, outName);  
        fprintf('Saved: %s\n', outName);

        % Reset for next panel
        tileIndex = 1;
        panelIndex = panelIndex + 1;
        tileImages = cell(panelSize, 1);
        tileHeights = zeros(panelSize, 1);
        tileWidths = zeros(panelSize, 1);
    end
end
