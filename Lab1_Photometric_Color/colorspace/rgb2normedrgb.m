function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb
[R,G,B] = getColorChannels(input_image);
norm_term = R + G + B;

% divide, term-wise, each channel by the sum of all 3
output_image(:,:,1) = R ./ norm_term;
output_image(:,:,2) = G ./ norm_term;
output_image(:,:,3) = B ./ norm_term;

end

