function new_im = Resize(im, inds, delta, dir, orig_size)
    if delta == 0
        if (dir == 1)
            new_im = im;
        end
        if (dir == 2)
            new_im = permute(im, [2 1 3]);
        end
        return;
    end
    new_width = orig_size(2) + delta;
    resized_im = zeros(orig_size(1), new_width, orig_size(3));
%     disp(size(resized_im));
%     disp(size(im));
    if (delta < 0)
        for i = 1:orig_size(1)
            to_keep = (inds(i, :) > -delta | inds(i, :) == 0);
%             assignin('base', 'a', to_keep);
            resized_im(i, :, :) = im(i, to_keep, :);
        end
    else
        for i = 1:orig_size(1)
            to_keep = (inds(i, :) >= -delta | inds(i, :) == 0);
%             assignin('base', 'a', to_keep);
            resized_im(i, :, :) = im(i, to_keep, :);
        end
    end
    if (dir == 2)
        new_im = permute(resized_im, [2, 1, 3]);
    end
    if (dir == 1)
        new_im = resized_im;
    end

%     A = who;
%     for i = 1:length(A)
%         assignin('base', A{i}, eval(A{i}));
%     end  