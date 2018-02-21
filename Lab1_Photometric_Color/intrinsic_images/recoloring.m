clear; close; clc;

% load the images
ball_original = imread('ball.png');
ball_shading = imread('ball_shading.png');
ball_reflectance = imread('ball_reflectance.png');

% showing the true colour by looking at the unique values in reflectance
true_color = unique(ball_reflectance, 'stable');
rgb = true_color(true_color ~= 0);
fprintf('rgb = (%f, %f, %f)\n', rgb(1), rgb(2), rgb(3))

% determine the height and width of the image
x = size(ball_reflectance, 1);
y = size(ball_reflectance, 2);

% changing all non-zero values to 255
green = ball_reflectance(:,:,2);
green(green~=0) = 255;

% reconstruction the reflectance image
ball_green = cat(3, zeros(x,y), green, zeros(x,y));

% reconstructing the complete image using I = R * S
reconstructed_green = uint16(ball_green) .* uint16(ball_shading);

% setting all the green values to zero
ball_reflectance(:,:,2) = zeros(x,y);

% setting all the non-zero values to 255
ball_reflectance(ball_reflectance~=0) = 255;

% reconstructing the complete image using I = R * S
reconstructed_magenta = uint16(ball_reflectance) .* uint16(ball_shading);

% showing the images
figure, imshow(ball_original), title('Original')
figure, imshow(reconstructed_green), title('Reconstructed Green')
figure, imshow(reconstructed_magenta), title('Reconstructed Magenta')

% saving the images
imwrite(reconstructed_green,'generated_images/reconstructed_green.png')
imwrite(reconstructed_magenta,'generated_images/reconstructed_magenta.png')