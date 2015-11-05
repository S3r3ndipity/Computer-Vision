function [Dx, Dy, w]=deriv(sigma)
% Create derivative-of-Gaussian kernels for horizontal and vertical derivatives.
% Input SIGMA is the standard deviation of the Gaussian. Use equation 4.21 
% in the Szelsiki book. Note that the equation has a type-o; the multiplicative 
% factor 1/sigma^3 should instead be 1/sigma^4; this does not affect the results
% though.
w = 2*floor(ceil(7*sigma)/2)+1;
[xx, yy] = meshgrid(-(w-1)/2:(w-1)/2,-(w-1)/2:(w-1)/2);

% Equation 4.21 from Szeliski's book.
Dx = -xx / (sigma^3) .* exp(-(xx.^2 + yy.^2) / (2*sigma^2));
Dy = -yy / (sigma^3) .* exp(-(xx.^2 + yy.^2) / (2*sigma^2));

return;