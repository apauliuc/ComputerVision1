% myPSNR(double(imread('images/image1_saltpepper.jpg')),double(imread('images/image1.jpg')))

function [ PSNR ] = myPSNR( orig_image, approx_image )
error = orig_image - approx_image;
PSNR = 20*log10(max(orig_image(:))/(sqrt(mean(error(:).^2))));
end

