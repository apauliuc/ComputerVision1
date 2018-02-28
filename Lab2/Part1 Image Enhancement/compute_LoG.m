function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        %method 1
        % first smooth the image with Gaussian kernel and
        % afterwards convolve with Laplacian filter
        smoothed_img = imfilter(image, gauss2D(0.5, 5));
        h = fspecial('laplacian');
        imOut = imfilter(smoothed_img, h, 'replicate');

    case 2
        %method 2
        % convolve the image directly with LoG kernel
        LoG_kernel = fspecial('log', 5, 0.5);
        imOut = imfilter(image, LoG_kernel, 'replicate', 'conv');
        
    case 3
        %method 3
        % set ratio to sqrt(2) and base stdev to 0.5
        ratio = sqrt(2);
        sigma_low = 0.5;
        sigma_high = sigma_low * ratio;
        
        % create the low and high Gaussian kernels
        filter_low = gauss2D(sigma_low, 5);
        filter_high = gauss2D(sigma_high, 5);
        
        % compute Difference of Gaussians (DoG)
        DoG = filter_high - filter_low;
        
        % convolve image with DoG and normalise to grayscale for better
        % visualising
        imOut = imfilter(image, DoG, 'replicate');
        imOut = mat2gray(imOut);
end
end

