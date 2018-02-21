clear; close; clc;

ball_original = imread('ball.png');
ball_shading = imread('ball_shading.png');
ball_reflectance = imread('ball_reflectance.png');

ball_reconstructed = uint16(ball_reflectance) .* uint16(ball_shading);

figure, imshow(ball_original), title('Original')
figure, imshow(ball_shading), title('Shading')
figure, imshow(ball_reflectance), title('Reflectance')
figure, imshow(ball_reconstructed), title('Reconstructed')

imwrite(ball_reconstructed,'generated_images/ball_reconstructed.png')