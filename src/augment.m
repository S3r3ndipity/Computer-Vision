function aug_mat = augment(bin_mat, iter)
    shift = mod(iter, 2);
    rows = size(bin_mat, 1);
    cols = size(bin_mat, 2);
    aug_mat = zeros(rows, cols + sum(bin_mat(1, :)));
    k = 1;
    for i = 1:rows
        for j = 1:cols
            if (bin_mat(i, j))
                aug_mat(i, k) = 1 - shift; %0 if odd iter (left), 1 if even (right)
                aug_mat(i, k + 1) = shift;
                k = k + 2;
            else
                aug_mat(i, k) = 0;
                k = k + 1;
            end
        end
    end
    