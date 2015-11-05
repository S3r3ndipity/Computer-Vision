function [enlarged, Binds] = enlarge(im, inds, bpt, max_iter)
    %max_iter must be divisible by 2 as of now

        
    assignin('base', sprintf('the_inds_%d', size(im, 1)), inds);
%     fprintf('%d, %d, %d x %d\n', max(inds(1, :)), bpt, size(im, 1), size(im, 2));
    if max(inds(1, :)) < bpt
        bpt = max(inds(1, :));
        max_iter = 1;
    end
    mid = max_iter/2;
%     fprintf('%d, %d\n', 1, mid);
    
    n_cols = size(im, 2) + max_iter * bpt;
    enlarged = zeros(size(im, 1), n_cols, size(im, 3));
    Binds = zeros(size(im, 1), n_cols);
    for i = 1:size(im, 1)
        to_dup = (inds(i, :) > 0 & inds(i, :) <= bpt); %0's and 1's

        i_ptr = 1;
        j = 1;
%         fprintf('%d, %d\n', 1, mid);
        while (i_ptr <= size(im, 2))
            if (to_dup(i_ptr)) %re-examine this
                lshift = max(1, i_ptr - 1);
                rshift = min(size(im, 2), i_ptr + 1);
                
                enlarged(i, floor(j+mid), :) = im(i, i_ptr, :);
                enlarged(i, j, :) = (im(i, i_ptr, :) + im(i, lshift, :)) ./ 2;
                enlarged(i, j+2*mid, :) = (im(i, i_ptr, :) + im(i, rshift, :)) ./ 2;
                Binds(i, floor(j+mid)) = inds(i, i_ptr);
                Binds(i, j) = -inds(i, i_ptr);
                Binds(i, j+2*mid) = -inds(i, i_ptr) - bpt;
                
                add_iter = max_iter - 2;
                for k = 1:add_iter/2
                    enlarged(i, j+k, :) = (enlarged(i, j+(k-1), :) + enlarged(i, j+mid, :)) ./ 2;
                    enlarged(i, j+2*mid-k, :) = (enlarged(i, j+2*mid-(k-1), :) + enlarged(i, j+mid, :)) ./ 2;
                    Binds(i, j+k, :) = -inds(i, i_ptr) - (2*k) * bpt;
                    Binds(i, j+2*mid-k, :) = -inds(i, i_ptr) - (1+2*k) * bpt;
                end
                j = j + max_iter + 1;
            else
                enlarged(i, j, :) = im(i, i_ptr, :);
                j = j + 1;
            end
            i_ptr = i_ptr + 1;            
        end
    end
%     A = who;
%     for i = 1:length(A)
%         assignin('base', A{i}, eval(A{i}));
%     end