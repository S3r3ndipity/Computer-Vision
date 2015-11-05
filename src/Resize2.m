function new_im = Resize(im, Vinds, delta_width, delta_height)
    new_im = im;
    if delta_width < 0
        new_height = size(im, 1) + delta_height;
        new_width = size(im, 2) + delta_width;
        resized_im = zeros(new_height, new_width, size(im, 3));
        
        for i = 1:size(im, 1)
            for k = 1:3
                slice = im(i, :, k);
                old_slice = im(i, :, k);
                inds = slice(Vinds > -delta_width | Vinds == 0);
                resized_im(i, :, k) = old_slice(inds);
            end
        end        
%         for i = 1:3
%             slice = im(:, :, i);
%             col_vec = slice(Vinds > -delta_width | Vinds == 0);
%             resized_im(:, :, i) = reshape(col_vec, [new_height, new_width]);
%         end
        new_im = resized_im;
%         big_Vinds = repmat(Vinds, [1, 1, 3]);
%         new_im = im(big_Vinds > -delta_width | big_Vinds == 0);
%         new_im = reshape(new_im, new_size);
    else
        disp('should be negative to shrink');
    end
    if delta_height < 0
        new_size = [size(im, 1) + delta_height, size(im, 2) + delta_width];
        new_im = reshape(im(Hinds > -delta_height), new_size);
    else
        disp('should be negative to shrink');
    end