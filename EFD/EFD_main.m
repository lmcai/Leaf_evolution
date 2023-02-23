% https://3010tangents.wordpress.com/2015/05/12/elliptic-fourier-descriptors/
%Segment the image
imwrite(im2bw(imread('cat.png')), 'bw_cat.png')

% set the number of harmonics
n=10

% trace exterior boundaries
chain = mk_chain('bw_cat.png');
[cc] = chaincode(chain);

%output first to n-th EFD coefficients
for i = 1 : n
	harmonic_coeff = calc_harmonic_coefficients(transpose([cc.code]), i);
        a(i) = harmonic_coeff(1, 1);
        b(i) = harmonic_coeff(1, 2);
        c(i) = harmonic_coeff(1, 3);
        d(i) = harmonic_coeff(1, 4);
end

% plot and compare EFD
% plot_chain_code(transpose([cc.code]));
% hold
% plot_fourier_approx(transpose([cc.code]), n, 1000, 0, 'r');





