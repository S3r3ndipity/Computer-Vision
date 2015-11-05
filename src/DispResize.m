%does Horizontal or Vertical
function DispResize(im, Vinds, Hinds, delta, dir)
    %cab(1);
	figure;
    imshow(im);
    %plot the seams on top of the original image
    hold on;
    if (dir == 1)
        inds = Vinds;
        [y, x] = find(inds <= -delta & inds > 0);
        plot(x, y, 'r.', 'MarkerSize', 2)
    end
    if (dir == 2)
        im = permute(im, [2, 1, 3]);
        inds = Hinds;
        [y, x] = find(inds <= -delta & inds > 0);
        plot(y, x, 'r.', 'MarkerSize', 2)
    end
    hold off;


    figure;
    resized_im = Resize(im, inds, delta, dir);
    imshow(resized_im);