function inds = SeamInds(paths, costs)
    inds = zeros(size(paths));
    [~, order] = sort(costs(end, :));
    assignin('base', 'order', order)
    for i = length(order):-1:1
        col = order(i);
        row = size(paths, 1);
        inds(row, col) = i;
%         display(row, col);
        while (row > 1)
            col = col + paths(row, col);
            row = row - 1;
            inds(row, col) = i;
        end
    end
%     disp(inds);
return