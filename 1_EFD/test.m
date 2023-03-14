[theta_shortaxis,theta_longaxis] = Eigenvectors(im); 
rotatedLeafBw = imrotate(im,(theta_longaxis + 90));
rotatedLeafBw = imrotate(rotatedLeafBw, 180);


LeafBwStats = regionprops(rotatedLeafBw,'all');
[RDMX,RDMY,RCMX,RCMY,RDNX,RDNY,RCNX,RCNY] = CalcAxis(LeafBwStats);

tabledatarotated = regionprops('Table',rotatedLeafBw, 'Centroid',...
    'Orientation', 'MajorAxisLength', 'MinorAxisLength','FilledArea',...
    'BoundingBox');

length_pixel = tabledatarotated.BoundingBox(1,4);
width_pixel = tabledatarotated.BoundingBox(1,3);


rotateBWFig = figure('name','Analysis 2 of Selected Image');
imshow(rotatedLeafBw);
    hold on, title('Rotated leaf BW with curves highlighted');
    plot(imgca,LeafBwStats(1).Centroid(:,1),...
    LeafBwStats(1).Centroid(:,2),'r*');
    line(RCMX,RCMY);
    line(RCNX,RCNY);
    %set(impixelinfo,'Position',[5, 1 300 20]);
    plot(outlineLeaf(:,2),outlineLeaf(:,1),'r--','LineWidth',2.5);
    %plots the outline 
    %subplot(1,2,2),imshow(croppedscale,'InitialMagnification',100);

area_pixel = LeafBwStats.Area;