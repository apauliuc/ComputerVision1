%% Part 1 - Load images and get matching keypoints
close all; clear; clc;

image1 = imread('boat1.pgm');
image2 = imread('boat2.pgm');

[matches, features_image1, features_image2] = keypoint_matching(image1, image2);

%% Part 2 - Display images and 50 matched keypoints
perm = randperm(size(matches,2));
points_image1 = transpose(features_image1(1:2,matches(1,perm(1:50))));
points_image2 = transpose(features_image2(1:2,matches(2,perm(1:50))));
plot_matching_points(image1, image2, points_image1, points_image2);

%% Part 3 - Perform RANSAC and transform image using best parameters
[m1, m2, m3, m4, t1, t2] = RANSAC(features_image1, features_image2, matches, 100, 3);

transform_image(image1, image2, m1, m2, m3, m4, t1, t2, 'own');