clear all;
close all;
im = imread('../data/bears.jpg');
imshow(im);
delta_vert = -20;
delta_horz = -20;
% convert image to double grayscale (so intensity values are in [0,1])
% if size(im,3)>1
% 	im = im2double(rgb2gray(im));
% else
% 	im = im2double(im);
% end
im = im2double(im);

%constants/parameters
sigma = 1;

e_R = energy(im(:, :, 1), sigma);
e_G = energy(im(:, :, 2), sigma);
e_B = energy(im(:, :, 3), sigma);
energies = e_R + e_G + e_B;
imshow(energies);
[paths, costs] = DPpath(energies);
Vinds = SeamInds(paths, costs);
hold on;
[y, x] = find(Vinds);
plot(x, y,'r.','MarkerSize',2)
hold off;

%to shrink
[row, col] = find(1 <= Vinds & Vinds <= delta_vert);
new_im = im(:, row, col);
% new_im = zeros(size(im, 1) - delta_vert, size(im, 2), size(im, 3));
imshow(new_im);

