function G = gauss1D( sigma , kernel_size )
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    %% solution
    % create initial vector of size kernel_size, centered around 0
    floored_size = floor(kernel_size / 2);
    kernel = (-floored_size:floored_size);
    
    % compute 1D Gaussian filter by formula and normalize it
    G = 1 / (sigma * sqrt(2 * pi)) * exp(- kernel .^ 2 / (2 * sigma ^ 2));
    G = G / sum(G);
end
