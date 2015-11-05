function [enlarged, Binds] = enlarge(im, inds, bpt)
    max_iter = 2;
    if max(inds(1, :)) < bpt
        bpt = max(inds(1, :));
        max_iter = 1;
    end
    n_cols = size(im, 2) + max_iter * bpt;
    enlarged = zeros(size(im, 1), n_cols, size(im, 3));
    for iter = 1:max_iter
        shift = -1; %avg with left
        if (mod(iter, 2) == 1)
            shift = 1; %avg with right
        end
        for i = 1:size(im, 1)
            to_dup = (inds(i, :) > -bpt | inds(i, :) == 0);
            len = length(to_dup);
            d_ptr = 1;
            i_ptr = 1;
            j = 1;
            while (j <= n_cols)
                if (d_ptr <= len && j == to_dup(d_ptr))
                    shifted = min(size(im, 2), max(1, i_ptr+shift));
                    enlarged(i, j, :) = (im(i, i_ptr, :) + im(i, shifted, :)) ./ 2;
                    d_ptr = d_ptr + 1;
                else
                    enlarged(i, j, :) = im(i, i_ptr, :);
                    i_ptr = i_ptr + 1;
                end
                j = j + 1;            
            end
        end
        im = enlarged(:, 1:j-1, :);
    end