%Set working environment

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 22;

%place high contrast leaf images in a folder and process using the rgb2bw_easy function
%set working directory
work_dir = '/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/030423/'
img_files=dir(join([work_dir,'*.JPG'],""));
img_files={img_files.name};
	
% work with high contrast
for i = 1:length(img_files)
	raw=imread(join([work_dir,string(img_files(i))],""));
	file_name=split(string(img_files(i)),'.JP')
	file_name=string(file_name(1))
	msk=rgb2bw_easy(raw);
	imwrite(msk,join([work_dir,file_name,'.bw.png'],""))
end


%place low contrast leaf images in a folder and process using the rgb2bw_lowcontrast function
%set working directory
work_dir = '/Users/lcai/Downloads/Orobanchaceae_leaf_architecture/leaf_shape/022322/'
img_files=dir(join([work_dir,'*.JPG'],""));
img_files={img_files.name};
	
for i = 1:length(img_files)
	raw=imread(join([work_dir,string(img_files(i))],""));
	file_name=split(string(img_files(i)),'.')
	file_name=string(file_name(1))
	msk=rgb2bw_lowcontrast(raw);
	imwrite(msk,join([work_dir,file_name,'.bw.png'],""))
end
