clear; close; clc;

% loading the images
ball_original = imread('ball.png');
ball_shading = imread('ball_shading.png');
ball_reflectance = imread('ball_reflectance.png');

% reconstructing the complete image using I = R * S
ball_reconstructed = uint16(ball_reflectance) .* uint16(ball_shading);

% showing the images
figure, imshow(ball_original), title('Original')
figure, imshow(ball_shading), title('Shading')
figure, imshow(ball_reflectance), title('Reflectance')
figure, imshow(ball_reconstructed), title('Reconstructed')

% save the reconstructed image
imwrite(ball_reconstructed,'generated_images/ball_reconstructed.png')