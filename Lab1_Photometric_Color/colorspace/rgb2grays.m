function [output_image] = rgb2grays(input_image)
% converts an RGB into grayscale by using 4 different methods
[R,G,B] = getColorChannels(input_image);
[h, w] = size(R);
output_image = zeros(h, w, 4);

% lightness method
% maybe search for better solution.. not quite nice to have for in for
for row = 1:h
    for col = 1:w
        values = [R(row,col) G(row,col) B(row,col)];
        output_image(row,col,1) = (max(values)+ min(values)) / 2;
    end
end

% average method
output_image(:,:,2) = (R + G + B) / 3;

% luminosity method
output_image(:,:,3) = 0.21 * R + 0.72 * G + 0.07 * B;

% built-in MATLAB function
% MATLAB uses the luminosity method with different coefficients
output_image(:,:,4) = rgb2gray(input_image);
 
end

