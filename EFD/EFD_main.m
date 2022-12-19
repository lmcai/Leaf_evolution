% https://3010tangents.wordpress.com/2015/05/12/elliptic-fourier-descriptors/
%Segment the image
imwrite(im2bw(imread('cat.png')), 'bw_cat.png')

% trace exterior boundaries
chain = mk_chain(bw_cat.png’);
[cc] = chaincode(chain);

%generate EFD
coeffs = calc_harmonic_coefficients(transpose([cc.code]), 70)





