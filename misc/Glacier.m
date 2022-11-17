clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 22;
cd '~/Downloads/'
bg1984=imread('Crop1-1984.png');
bg1984=rgb2gray(bg1984);
bg1984 = im2double(bg1984);
bg1984 = adapthisteq(bg1984);

bg2014=imread('Crop1-2014.png');
bg2014=rgb2gray(bg2014);
bg2014 = im2double(bg2014);
bg2014 = adapthisteq(bg2014);


imshowpair(bg1984,bg2014,'montage')

diffIce = bg1984 - bg2014;
diffIce = rescale(diffIce);
imshow(diffIce)
ice1984=diffIce>0.7;
imshow(ice1984)
melt=(nnz(ice1984)/numel(ice1984))*100


bg1984bw=imbinarize(bg1984);
bg2014bw=imbinarize(bg2014);
imshowpair(bg1984bw,bg2014bw,'montage')
imshowpair(bg1984bw,bg2014bw)

bg1984=imread('Crop1-1984.png');
[r1984,g1984,b1984]=imsplit(bg1984);
montage({r1984,g1984,b1984})
bg1984bw=imbinarize(b1984);
imshow(bg1984bw)

bg2014=imread('Crop1-2014.png');
[r2014,g2014,b2014]=imsplit(bg2014);
bg2014bw=imbinarize(b2014);