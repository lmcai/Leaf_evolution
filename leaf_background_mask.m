function msk = MskGen(img)
   	%read in image, adjust contrast, spatial filtering to reduce noise, convert to gray, binarize
	y = rgb2gray(img);
	yAdj = imadjust(y);
	F = fspecial("average",3);
	ysmooth = imfilter(yAdj,F,'replicate');
	msk = imbinarize(ysmooth);

	%%remove connected small objects, blur or morphological operation to open the image
	msk=bwareaopen(msk, 10000);
	%morphological operation isn't as good as blurring
	SE = strel("disk",50);
	yopen = imopen(ysmooth,SE);
	msk=imbinarize(yopen);
	msk=~msk;
	%alternative: blur the image, but corners and borders have artificial pixels
	%windowSize = 51;
	%kernel = ones(windowSize) / windowSize ^ 2;
	%msk_blurry = conv2(single(msk), kernel, 'same');
	%msk_blurry = msk_blurry > 0.5;
	%msk=imcomplement(msk_blurry);

	%sum and plot column values
	%S=sum(msk,1);
	%plot(S)
end

img_files=dir('~/Downloads/Orobanchaceae_venation/*.tif');
img_files={img_files.name};
for i = 1:length(img_files)
	raw=imread(join(['~/Downloads/Orobanchaceae_venation/',string(img_files(i))],""));
	file_name=split(string(img_files(i)),'.')
	file_name=string(file_name(1))
	msk=MskGen(raw)
	imwrite(msk,join(['~/Downloads/Orobanchaceae_venation/',file_name,'_mask.png'],""))
	imwrite(raw,join(['~/Downloads/Orobanchaceae_venation/',file_name,'.png'],""))
end