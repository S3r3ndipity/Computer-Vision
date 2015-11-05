function col_inds = LowestSeam(paths, costs)
    col_inds = zeros(size(paths, 1), 1);
    [~, col] = min(costs(end, :));
%     assignin('base', 'lowest_seam_val', col)
    row = size(paths, 1);
    col_inds(row) = col;
    %build col_inds from bottom to top
	while (row > 1)
        col = col + paths(row, col);
        row = row - 1;
        col_inds(row) = col;
	end
return