%Set working environment

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 22;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%place leaf images in a folder and process using the rgb2bw_lowcontrast function
%set working directory
work_dir = '/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/022322/'
img_files=dir(join([work_dir,'*.JPG'],""));
img_files={img_files.name};
	
for i = 1:length(img_files)
	raw=imread(join([work_dir,string(img_files(i))],""));
	file_name=split(string(img_files(i)),'.JP');
	file_name=string(file_name(1))
	msk=rgb2bw_lowcontrast(raw);
	imwrite(msk,join([work_dir,file_name,'.bw.png'],""))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For dissected leaves with potentially overlapping parts, skip the 'hole filling' step and use the rgb2bw_dissectedleaf function
%set working directory
work_dir = '/Users/lcai/Downloads/temp/'
img_files=dir(join([work_dir,'*.JPG'],""));
img_files={img_files.name};
	
for i = 1:length(img_files)
	raw=imread(join([work_dir,string(img_files(i))],""));
	file_name=split(string(img_files(i)),'.JP');
	file_name=string(file_name(1))
	msk=rgb2bw_dissectedleaf(raw);
	imwrite(msk,join([work_dir,file_name,'.bw.png'],""))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for smaller leaves whose images are taken with Canon EOS, they needs to be exported to tiff first,
% then croped

work_dir = '/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/022322/'
img_files=dir(join([work_dir,'*.tiff'],""));
img_files={img_files.name};
	

for i = 1:length(img_files)
	raw=imread(join([work_dir,string(img_files(i))],""));
    % if dealing with tiff file
    raw(:,:,4) = [];
    [rows, cols, chans] = size(raw)
    if rows>cols
        topRow = 850;
        bottomRow = 4500;
        leftColumn = 100;
        rightColumn = 3300;
    else
        topRow = 100;
        bottomRow = 3300;
        leftColumn = 850;
        rightColumn = 4500;
    end 
    croppedImage = raw(topRow:bottomRow, leftColumn:rightColumn);
	file_name=split(string(img_files(i)),'.')
	file_name=string(file_name(1))
	msk=rgb2bw_croppedtiff(croppedImage);
	imwrite(msk,join([work_dir,file_name,'.bw.png'],""))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for image taken with Nikon imaging center, use edge detection instead
work_dir = '/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/Nikon_imagingcenter/'
img_files=dir(join([work_dir,'*.tif'],""));
img_files={img_files.name};
	

for i = 1:length(img_files)
	raw=imread(join([work_dir,string(img_files(i))],""));
	BW=rgb2gray(raw);
	BW=edge(BW);
	SE = strel("disk",7);
	filledMask = imclose(BW,SE);
	filledMask=bwareafilt(filledMask,1);
	filledMask=imfill(filledMask,"holes");
	file_name=split(string(img_files(i)),'.')
	file_name=string(file_name(1))
	imwrite(filledMask,join([work_dir,file_name,'.bw.png'],""))
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MISC
%place high contrast leaf images in a folder and process using the rgb2bw_easy function
%set working directory
work_dir = '/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/030423/'
img_files=dir(join([work_dir,'*.JPG'],""));
img_files={img_files.name};
	
% work with high contrast
for i = 1:length(img_files)
	raw=imread(join([work_dir,string(img_files(i))],""));
	file_name=split(string(img_files(i)),'.JP');
	file_name=string(file_name(1))
	msk=rgb2bw_easy(raw);
	imwrite(msk,join([work_dir,file_name,'.bw.png'],""))
end
