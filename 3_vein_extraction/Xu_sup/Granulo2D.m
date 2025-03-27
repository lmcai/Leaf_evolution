function [imda,imra,imod] = Granulo2D(im,si,no)
%% Granulometry
s = 2:si; %size of the disk
o = 0:180/no:180-180/no; %number of orientation
if max(im(:)) <=1
    im = uint8(255.*im);
else
    im = uint8(im);
end
imol = zeros(size(im,1),size(im,2),length(s),length(o),'uint8');
imod = zeros(size(im,1),size(im,2),length(s),'uint8');
% imol = zeros(size(im,1),size(im,2),length(s),length(o));%original
% imod = zeros(size(im,1),size(im,2),length(s));%original
for i=1:length(s)
   for j=1:length(o)
       se = strel('line',s(i),o(j));
       %se = BOEllipse2D([s(i),round(s(i)/no)],o(j));
       imol(:,:,i,j) = imopen(im,se);
   end
   se = strel('disk',round(s(i)/2));% original
   imod(:,:,i) = imopen(im,se);
end
%% Diff
imd = zeros(size(im,1),size(im,2),length(s),'uint8');
imr = zeros(size(im,1),size(im,2),length(s),'single');
imm = zeros(size(im,1),size(im,2),length(s),'uint8');
% imd = zeros(size(im,1),size(im,2),length(s));% original
% imr = zeros(size(im,1),size(im,2),length(s));% original
% imm = zeros(size(im,1),size(im,2),length(s));% original

triv = imod==0;
for i=1:length(s)
   imm(:,:,i) = max(squeeze(imol(:,:,i,:)),[],3);   % Max for all lines
   imd(:,:,i) = imm(:,:,i) - imod(:,:,i);           % Diff betwen disk and line
   imr(:,:,i) = single(imm(:,:,i)) ./ single(imod(:,:,i)); % Ratio
end
imr(triv) = 0;
imda = single(max(imd,[],3));
imra = max(imr,[],3);
imda= mat2gray(imda);
end
