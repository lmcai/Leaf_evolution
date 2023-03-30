function k = curvature(curve)
% Calculates the curvature of a 2D curve at each point.
% The input curve should be a cscvn object.

syms t;
x = curve(1);
y = curve(2);
dx = diff(x);
dy = diff(y);
d2x = diff(dx);
d2y = diff(dy);
k = simplify((dx*d2y - d2x*dy) / ((dx^2 + dy^2)^(3/2)));
k = double(subs(k, t, curve.breaks));