clear all;
close all;
im = im2double(imread('../data/twins_small.jpg'));
% Pre-compute and put Vinds in the workspace
imT = permute(im, [2, 1, 3]);
[Hinds, ~] = PreCompute(imT);
[Vinds, init_energies] = PreCompute(im);
figure;
imshow(init_energies);

% total_increase = 1; %e.g. 1 means increase by 100%
% prop = 0.5;
% half_iter = floor(total_increase/(2*prop));
% [Venlarged, VBinds] = enlarge(im, Vinds, floor(size(im, 2)*prop), 2*half_iter);
% [Henlarged, HBinds] = enlarge(imT, Hinds, floor(size(im, 1)*prop), 2*half_iter);
% 
% figure;
% imshow(Venlarged);
% % hold on;
% % [y, x] = find(VBinds >= -2 * size(im, 2)/2 & VBinds < 0);
% % plot(x, y, 'r.', 'MarkerSize', 2)
% % hold off;
% 
% figure;
% imshow(permute(Henlarged, [2 1 3]));
% % hold on;
% % [x, y] = find(HBinds >= -2 * size(im, 1)/2 & HBinds < 0);
% % plot(x, y, 'r.', 'MarkerSize', 2)
% % hold off;