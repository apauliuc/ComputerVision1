function [Gx, Gy, im_magnitude, im_direction] = compute_gradient(image)
% create Sobel kernel and find horizontal and vertical components
sobel_kernel = [1 0 -1; 2 0 -2; 1 0 -1];
Gx = conv2(image, sobel_kernel, 'same');
Gy = conv2(image, transpose(sobel_kernel), 'same');
% Gx = double(imfilter(image, sobel_kernel, 'replicate'));
% Gy = double(imfilter(image, transpose(sobel_kernel), 'replicate'));

% compute gradient magnitue and direction
im_magnitude = sqrt(Gx .^ 2 + Gy .^ 2);
im_direction = -atan2(Gy, Gx);
end