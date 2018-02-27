function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        %method 1
        smoothed_img = imfilter(image, gauss2D(0.5, 5));
        h = fspecial('laplacian');
        imOut = imfilter(smoothed_img, h, 'replicate');

    case 2
        %method 2
        LoG_kernel = fspecial('log', 5, 0.5);
        imOut = imfilter(image, LoG_kernel, 'replicate', 'conv');
        
    case 3
        %method 3
        ratio = 1.6;
        sigma1 = 0.5;
        sigma2 = sigma1 * ratio;

        gaussian1 = imgaussfilt(image, sigma1, 'FilterSize', 5);
        gaussian2 = imgaussfilt(image, sigma2, 'FilterSize', 5);
        
%         filter1 = fspecial('Gaussian', 5, sigma1);
%         filter2 = fspecial('Gaussian', 5, sigma2);
%         
%         gaussian1 = imfilter(image, filter1, 'replicate');
%         gaussian2 = imfilter(image, filter2, 'replicate');
        
        imOut = gaussian2 - gaussian1;
end
end

