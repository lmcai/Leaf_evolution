Bound = bwboundaries(im, 8,'noholes');
outlineLeaf = cell2mat(Bound); %make outline a matrix
[normalized_outline, ratioScale] = normalize_outline(outlineLeaf);
[efdOutline, coefficients] = efd_setup(numHarmonics, normalized_outline, ratioScale);