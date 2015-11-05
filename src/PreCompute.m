function [Vinds, init_energies] = PreCompute(im, p_mask, e_mask)
    % close all;
    if size(im,3) > 1
        RGB = 1;
    end
    has_pmask = 0;
    has_emask = 0;
    if (~isempty(p_mask))
        has_pmask = 1;
    end
    if (~isempty(e_mask))
        has_emask = 1;
    end

    %constants/parameters
    sigma = 1;
    n_rows = size(im, 1);
    n_cols = size(im, 2);
    n_seams = n_cols - 1;

    Vinds = zeros(n_rows, n_cols);
    %each (i,j) contains the col index removed in the ith row with seam j
    removed = zeros(n_rows, n_cols);
    Real_rem = zeros(n_rows, 1);
    %keeps track of the real column index
    real_inds = repmat(1:n_cols, [n_rows, 1]); 
    for j = 1:n_seams
        fprintf('%d\n', j);
        if (RGB == 1)
            e_R = energy(im(:, :, 1), sigma);
            e_G = energy(im(:, :, 2), sigma);
            e_B = energy(im(:, :, 3), sigma);
            energies = e_R + e_G + e_B; %always non-negative
        else
            energies = energy(im, sigma);
        end
%         size(energies)
        %erase (e_mask has -100's where you want to erase)
        if (has_emask)
            energies = min(energies, e_mask);
        end
        %protect (p_mask has 1000's where you want to protect)
        if (has_pmask)
            energies = max(energies, p_mask);
        end
        if (has_emask && j == 1)
            assignin('base', 'e_mask', e_mask);
            assignin('base', 'p_mask', p_mask);
            assignin('base', 'energies', energies); 
        end
        
        if (j == 1)
            init_energies = energies;
        end
        %if everything in one row is protected
        if (sum(sum(find(energies == 1000), 2) == size(im, 2)) > 0)
            break;
        end
        [paths, costs] = DPpath(energies);
        %ith entry contains column index removed in ith row for this seam
        Sub_rem = LowestSeam(paths, costs);
        new_im = zeros(size(im, 1), size(im, 2) - 1, size(im, 3));
        new_real_inds = zeros(size(im, 1), size(im, 2) - 1);
        if (has_pmask)
            new_pmask = zeros(size(im, 1), size(im, 2) - 1);
        end
        if (has_emask)
            new_emask = zeros(size(im, 1), size(im, 2) - 1);
        end

        for i = 1:n_rows
            to_keep = [1:Sub_rem(i)-1, Sub_rem(i)+1:size(im, 2)];
            new_im(i, :, :) = im(i, to_keep, :);
            Real_rem(i) = real_inds(i, Sub_rem(i));
            new_real_inds(i, :) = real_inds(i, to_keep);
            if (has_pmask)
                new_pmask(i, :) = p_mask(i, to_keep);
            end
            if (has_emask)
                new_emask(i, :) = e_mask(i, to_keep);
            end
        end
        im = new_im; %image now has seam removed
        real_inds = new_real_inds;
        if (has_pmask)
            p_mask = new_pmask;
        end
        if (has_emask)
            e_mask = new_emask;
        end

        removed(:, j) = Real_rem; %add another column for a seam removed
    end
    for i = 1:n_rows
        for j = 1:n_seams
            %j is the seam number
            if (removed(i, j))
                Vinds(i, removed(i, j)) = j;
            end
        end
    end
%     A = who;
%     for i = 1:length(A)
%         assignin('base', A{i}, eval(A{i}));
%     end

%     %Show all computed seams
%     hold on;
%     [y, x] = find(Vinds);
%     plot(x, y,'r.','MarkerSize',2)
%     hold off;