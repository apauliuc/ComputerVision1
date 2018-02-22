function G = gauss2D( sigma , kernel_size )
    % get 1D Gaussian filter with given parameters
    G_1D = gauss1D(sigma, kernel_size);
    % multiply the transpose of 1D Gaussian filter with itself
    % gives a (kernel_size x kernel_size) matrix
    G = transpose(G_1D) * G_1D;
end
