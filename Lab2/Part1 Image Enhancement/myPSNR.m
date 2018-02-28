function [ PSNR ] = myPSNR( orig_image, approx_image )
% convert images to double for computation
orig_image = double(orig_image);
approx_image = double(approx_image);
% find error
error = orig_image - approx_image;
% compute PSRN by formula
PSNR = 20*log10(max(orig_image(:))/(sqrt(mean(error(:).^2))));
end

