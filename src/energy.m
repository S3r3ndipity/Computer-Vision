function grads = energy(im, sigma)
    % sample the image gradient at these localized points. (The 
    %   localized points are assumed to be in an Nx2 array X 
    %   with rows of the form (x,y).)
    [Dx, Dy, w] = deriv(sigma);
    width = (w-1)/2; %w is always odd
    IDoG_x = conv2(add_border(im, 'dup', width), Dx, 'valid'); %x-component of gradient
    IDoG_y = conv2(add_border(im, 'dup', width), Dy, 'valid'); %y-component of gradient
%     G_x = interp2(IDoG_x, X(:, 1), X(:, 2)); %interpolated
%     G_y = interp2(IDoG_y, X(:, 1), X(:, 2));
%     G = [G_x, G_y];
    grads = IDoG_x .^ 2 + IDoG_y .^ 2;
end