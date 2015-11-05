function new_im = Resize(im, Vinds, delta_width, delta_height)
    new_im = im;
    if delta_width < 0
        new_height = size(im, 1) + delta_height;
        new_width = size(im, 2) + delta_width;
        resized_im = zeros(new_height, new_width, size(im, 3));
        for i = 1:size(im, 1)
            to_keep = (Vinds(i, :) > -delta_width | Vinds(i, :) == 0);
            resized_im(i, :, :) = im(i, to_keep, :);
        end        
        new_im = resized_im;
    else
        disp('should be negative to shrink');
    end
    if delta_height < 0
        new_size = [size(im, 1) + delta_height, size(im, 2) + delta_width];
        new_im = reshape(im(Hinds > -delta_height), new_size);
    else
        disp('should be negative to shrink');
    end
    
%     figure;
%     imshow(im);
%     hold on;
%     n_seams = 
%     [y, x] = find(Vinds <= n_seams & Vinds > 0);
%     plot(x, y,'r.','MarkerSize',2)
%     hold off;
% 
%     %to shrink
%     figure;
%     resized_im = Resize(im, Vinds, -n_seams, 0);
%     imshow(resized_im);