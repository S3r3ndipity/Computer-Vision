clear all;
close all;
im = imread('../data/twins_small.jpg');
imshow(im);
delta_vert = -20;
delta_horz = -20;
im = im2double(im);
if size(im,3) > 1
    RGB = 1;
end

%constants/parameters
sigma = 1;
n_rows = size(im, 1);
n_cols = size(im, 2);
n_seams = 20;

Vinds = zeros(n_rows, n_cols);
Hinds = zeros(n_rows, n_cols);
%each row contains the column indices removed in that row (one for each
%seam
removed = zeros(n_rows, n_cols);
Real_rem = zeros(n_rows, 1);
for j = 1:n_seams
    if (RGB == 1)
        e_R = energy(im(:, :, 1), sigma);
        e_G = energy(im(:, :, 2), sigma);
        e_B = energy(im(:, :, 3), sigma);
        energies = e_R + e_G + e_B;
    else
        energies = energy(im, sigma);
    end
    if (j == 1)
        figure;
        imshow(energies);
    end
    [paths, costs] = DPpath(energies);
    %ith entry contains column index removed in ith row for this seam
    Sub_rem = LowestSeam(paths, costs);
    new_im = zeros(size(im, 1), size(im, 2) - 1, size(im, 3));
    for i = 1:n_rows
        to_keep = [1:Sub_rem(i)-1, Sub_rem(i)+1:size(im, 2)];
        new_im(i, :, :) = im(i, to_keep, :);
    end
    im = new_im; %image now has seam removed
    for i = 1:n_rows
        Real_rem(i) = Sub_rem(i) + sum(0 < removed(i, :) & removed(i, :) <= Sub_rem(i));
    end
    removed(:, j) = Real_rem; %add another column to removed
end
for i = 1:n_rows
    for j = 1:n_seams
        %j is the seam number
        Vinds(i, removed(i, j)) = j;
    end
end
hold on;
[y, x] = find(Vinds);
plot(x, y,'r.','MarkerSize',2)
hold off;

%to shrink
figure;
imshow(im);

