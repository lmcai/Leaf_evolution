% https://3010tangents.wordpress.com/2015/05/12/elliptic-fourier-descriptors/
%Segment the image
imwrite(im2bw(imread('cat.png')), 'bw_cat.png')

% trace exterior boundaries
chain = mk_chain('bw_cat.png');
[cc] = chaincode(chain);

%generate EFD
plot_chain_code(transpose([cc.code]));
hold
plot_fourier_approx(transpose([cc.code]), 10, 1000, 0, 'r');





