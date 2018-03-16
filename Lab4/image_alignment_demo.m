%% Part 1 - Load images and get matching keypoints
close all; clear; clc;

image1 = imread('boat1.pgm');
image2 = imread('boat2.pgm');

% get matching keypoints
[matches, features_image1, features_image2] = keypoint_matching(image1, image2);

%% Part 2 - Display images and 50 matched keypoints
plot_matching_points(image1, image2, features_image1, features_image2, matches, 50);

%% Part 3 - Perform RANSAC
% set 6th argument to TRUE to display images with transformed points,
% matched to input image for each iteration
[m1, m2, m3, m4, t1, t2] = RANSAC(features_image1, features_image2, matches, 100, 10, false, image1, image2);

%% Part 3 - Transform image using best parameters
% transform image1 with own/matlab implementation
implementation = 'matlab'; % can be 'own' or 'matlab'
new_image = transform_image(image1, m1, m2, m3, m4, t1, t2, implementation);

figure, imshow(image1), title('Initial image');
figure, imshow(image2), title('Desired output image');
figure, imshow(new_image), title(sprintf('Transformed image with %s implementation', implementation));