clear; close; clc;

ball_original = imread('ball.png');
ball_shading = imread('ball_shading.png');
ball_reflectance = imread('ball_reflectance.png');

true_color = unique(ball_reflectance, 'stable');
rgb = true_color(true_color ~= 0);
fprintf('rgb = (%f, %f, %f)\n', rgb(1), rgb(2), rgb(3))

x = size(ball_reflectance, 1);
y = size(ball_reflectance, 2);

green = ball_reflectance(:,:,2);
green(green~=0) = 255;
ball_green = cat(3, zeros(x,y), green, zeros(x,y));
reconstructed_green = uint16(ball_green) .* uint16(ball_shading);

ball_reflectance(:,:,2) = zeros(x,y);
ball_reflectance(ball_reflectance~=0) = 255;
reconstructed_magenta = uint16(ball_reflectance) .* uint16(ball_shading);

figure, imshow(ball_original), title('Original')
figure, imshow(reconstructed_green), title('Reconstructed Green')
figure, imshow(reconstructed_magenta), title('Reconstructed Magenta')

imwrite(reconstructed_green,'generated_images/reconstructed_green.png')
imwrite(reconstructed_magenta,'generated_images/reconstructed_magenta.png')