%does both shrinking and enlarging, and Vertical and Horizontal
function [resized_im] = GenResize(im, Venlarged, Henlarged, Vinds, Hinds, VBinds, HBinds, delta, dir)
    orig_im = im;
    if (dir(1) == 'w')
        dir = 1;
    end
    if (dir(1) == 'h')
        dir = 2;
    end
  
    if (delta > 0)
        if (dir == 1)
            use_im = Venlarged;
            inds = VBinds;
        end
        if (dir == 2)
            use_im = Henlarged; %why don't I permute this???
            inds = HBinds;
            orig_im = permute(im, [2 1 3]);
        end
    else
        if (dir == 1)
            use_im = im;
            inds = Vinds;
        end
        if (dir == 2)
            use_im = permute(im, [2, 1, 3]);
            inds = Hinds;
            orig_im = permute(im, [2 1 3]);
        end
    end
    %cab(1);
% 	figure;
% 	imshow(use_im);
    
    %plot the seams on top of the original image
%     hold on;
%     if (dir == 1)
%         [y, x] = find(inds <= -delta & inds > 0);
%         plot(x, y, 'r.', 'MarkerSize', 2)
%     end
%     if (dir == 2)
%         [x, y] = find(inds <= -delta & inds > 0);
%         plot(x, y, 'r.', 'MarkerSize', 2)
%     end
%     hold off;
    
    resized_im = Resize(use_im, inds, delta, dir, size(orig_im));
%     figure;
%     imshow(resized_im);