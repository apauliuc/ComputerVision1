% myPSNR('images/image1.jpg','images/image1_saltpepper.jpg')

function [ PSNR ] = myPSNR( orig_image_path, approx_image_path )
orig_image = double(imread(orig_image_path));
approx_image = double(imread(approx_image_path));
error = orig_image - approx_image;
PSNR = 20*log10(max(orig_image(:))/(sqrt(mean(error(:).^2))));
end

