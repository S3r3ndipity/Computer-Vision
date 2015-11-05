function [paths, costs] = DPpath(energies)
    %finds vertical seams
    [nrows, ncols] = size(energies);
    costs = zeros(size(energies));
%     disp(size(energies));
    %-1 if next element on path from here to top is up-left, 0 if up, 1 if
    %up-right
    paths = zeros(size(energies));
    costs(1, :) = energies(1, :);
    for i = 2:nrows
        [val, ind] = min([costs(i-1, 1), costs(i-1, 2)]);
        costs(i, 1) = energies(i, 1) + val;
        paths(i, 1) = ind - 1; %ind is 1 or 2 --> 0 or 1
        [val, ind] = min([costs(i-1, ncols-1), costs(i-1, ncols)]);
        costs(i, ncols) = energies(i, ncols) + val;
        paths(i, ncols) = ind - 2; %ind is 1 or 2 --> -1 or 0
        for j = 2:ncols-1
            [val, ind] = min([costs(i-1, j-1), costs(i-1, j), costs(i-1, j+1)]);
            costs(i, j) = energies(i, j) + val;
            paths(i, j) = ind - 2;
        end
    end
return
